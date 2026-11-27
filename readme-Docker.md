# ShoalsAA local WordPress Compose setup

This file records the discussion and setup decisions for running a local WordPress copy of ShoalsAA with Docker Compose.

## Conversation record

- User

I reported a pull failure while Docker was downloading `wordpress:7.1.4-php8.4-apache`. Docker returned an `EOF` from `production.cloudfront.docker.com`.

- Assistant

Inspected the Compose project and retried the pull. WordPress downloaded on retry; MySQL initially returned the same CloudFront EOF, then downloaded on a subsequent retry. These were transient layer-download failures, not a Compose syntax problem.

- User

Asked whether the faulty Compose YAML could be edited or replaced if the stack started successfully.

- Assistant

Started the stack, found host port 8080 was already occupied by MiniTool ShadowMaker's `MTAgentService`, and changed the existing host mapping to `8081:80`. Both services then ran and WordPress returned HTTP 200.

- User

Asked for the best approach to create a Compose setup for an existing WordPress site, including its active plugins and a Mailpit instance for test email.

- Assistant

Recommended restoring a site copy with its database and `wp-content`, persisting the database and WordPress files, routing SMTP to Mailpit (`mailpit:1025`), exposing Mailpit's UI, and checking production-dependent plugins and credentials.

- User

Asked whether a current WPvivid backup could be imported into a newly created WordPress instance and requested an explanation of database URL updates for local use.

- Assistant

Confirmed that restoring a full backup into a separate local instance is a reasonable workflow. Explained that production URLs in WordPress options and content should be updated with a serialization-aware replacement method, not raw SQL, and that `home` and `siteurl` must point to the local URL.

- User

Reported that restoring a WPvivid backup from `https://shoalsaa.org` to `https://test.shoalsaa.org` had worked well. Explained that `MTAgentService` was removed, so the local Compose stack should use standard host port 8080. Also requested upload limits sufficient for WPvivid backup ZIP files, with the largest observed at 204032 KB, and specified WordPress 7.1.5 with PHP 8.4 on Ubuntu 26.04.1 LTS.

- Assistant

Checked the WordPress image tags. The official WordPress image provides a WordPress 7.1.5 PHP 8.3 Apache tag, but not a PHP 8.4 Apache tag. The implementation therefore takes WordPress core from the official 7.1.5 image and runs it on a custom PHP 8.4 Apache image. Ubuntu 26.04.1 LTS is the host OS; the PHP base container is Debian-based and is independent of the host distribution.

The first build started, but a named volume masked WordPress core files baked into the image. A custom entrypoint was added to initialize a new empty volume from the pinned core and copy the custom configuration on first start.

- User

Provided Docker Desktop's Gordon AI with project-specific details from
shoalsaa.org and DreamHost to guide the container configuration. Asked to use
the resulting root Compose setup, restore a test-site WPvivid backup locally,
and keep the root and nested Compose files aligned for the unfinished merge.

- Assistant

Reviewed the generated configuration against the nested project copy and
confirmed that the root `docker-compose.yml` is the configuration currently
applied. The nested Compose file was synchronized with it for merge parity;
its relative paths assume the repository root, so do not run it standalone
from the nested directory. After removing the application that previously
occupied port 8080 and restarting Windows, the stack was running on
`localhost:8080` and returned HTTP 200 with the WordPress installation screen.

- User

Reported logging in to the new local WordPress stack, doing initial setup,
installing WPvivid, connecting it to the normal Dropbox backup location, and
starting a restore. WPvivid's progress display timed out at about 86%; the
browser lost communication with the site and the user could not log back in.

- Assistant

Inspected containers, Compose configuration, logs, disk usage, database state,
and the WPvivid restore log. All three containers remained running; WordPress
and MySQL had zero restarts and no OOM indication, MySQL was healthy, and the
login endpoint later returned HTTP 200. The WordPress log recorded repeated
HTTP 503 responses during WPvivid AJAX/admin requests. The WPvivid restore log
shows extraction of themes, plugins, uploads, core, and the start of database
import, but ends at SQL offset 31,459,533 without a completion entry. The
WordPress database contains 229 tables with the temporary `tmpbfed4d_` prefix
and only 13 tables with the original `wp_` prefix, so the backup restore is
incomplete and must not be treated as successful. No root cause for the 503s
was established from available logs.

The recommended response was to preserve the current volumes, avoid another
restore until a database dump is saved, and never use `docker compose down -v`
while trying to recover. After a backup, inspect the WPvivid log and retry only
if WPvivid's workflow supports safely resuming or restarting. If it fails
again, enable PHP error logging before retrying to capture a more useful cause.

### User

Requested a local WordPress admin account with username `districtone` and a
configured password.

### Assistant

Added Compose environment variables for one-time local admin creation and
updated `docker/wordpress-entrypoint.sh` to install the account only when
WordPress is uninstalled. Troubleshooting found the container entrypoint had
Windows CRLF line endings, then revealed that the existing `wordpress_data`
volume contained core files but no `wp-config.php`. The entrypoint was fixed to
copy the config whenever it is missing, and the WordPress CLI bootstrap was
updated to use install mode and localhost request variables.

Verified: the WordPress image rebuilt, Compose restarted the WordPress service
without deleting the named volumes, all services were running, the `wp_users`
table contained `districtone`, and WordPress confirmed the configured password
matched the user's hash. `http://localhost:8080/wp-login.php` returned HTTP 200
with a login form. These Compose credentials are local-test credentials only;
change them before exposing the stack beyond the local machine. Bootstrap does
not reset credentials for an already-installed WordPress site.

## Files and behavior

- `docker-compose.yml` runs MySQL, WordPress, and Mailpit.
- WordPress is available at `http://localhost:8080`.
- Mailpit's web inbox is available at `http://localhost:8025`; SMTP inside the Compose network is `mailpit:1025`.
- `docker/Dockerfile` combines WordPress 7.1.5 core with PHP 8.4 Apache and required PHP extensions.
- `docker/wordpress-entrypoint.sh` initializes an empty persistent volume with the pinned core and local `wp-config.php`.
- `docker/php.ini` allows 512 MB individual uploads and a 550 MB POST body, with longer request timeouts. This exceeds the observed 204032 KB archive size.
- `wordpress_data` persists WordPress files; `mysql_data` persists the database.
- The local site-report plugin folder is mounted into the plugin directory.
- `docker/wp-config.php` uses Compose environment values and points WordPress at `http://localhost:8080`.
- At the latest diagnostic check, all three containers were running; the
  database and Mailpit health checks passed. The WPvivid restore had begun but
  did not complete, so do not consider the local site a verified restore.
- Place the local working copy of a WPvivid backup in
  `local-backups\wpvivid\`. The repository `.gitignore` excludes this folder;
  never add backup archives to Git or push them.

## Historical database administration UI

An earlier Compose revision (commit `ce7cbd5`, 2026-11-19) included
`phpmyadmin:5` at `http://localhost:8081` and set `UPLOAD_LIMIT` to `64M`.
The original reason for that limit was not recorded. It may have been meant
for importing a database dump through phpMyAdmin, but this is unconfirmed.
The current Compose file does not run phpMyAdmin; treat it as an option to
revisit only if browser-based database administration or imports are needed.

## Start and validate

From the repository root:

```powershell
docker compose build --pull wordpress
docker compose pull db mailpit
docker compose up -d --no-build
docker compose ps
```

The WordPress service uses a locally built image. Pull Dockerfile base images during the build, pull registry services separately, then start the local image without trying to pull it.

Then open `http://localhost:8080` and `http://localhost:8025`. Set the site's SMTP plugin to host `mailpit`, port `1025`, with no TLS or authentication for this isolated local network. Send a test message and verify it appears in Mailpit.

## Managing files and copying WPvivid backups

Use Windows File Explorer or VS Code to browse and edit files that are in the project folder. WordPress's full filesystem is stored in the Docker named volume `wordpress_data`, so it does not show up as an ordinary project subfolder. Use `docker compose exec` to inspect the container, and `docker cp` to copy files between the container and the host.

From PowerShell, at the repository root, create the local backup folder and list WPvivid's backup files:

```powershell
New-Item -ItemType Directory -Force .\local-backups\wpvivid
docker compose exec wordpress sh -c "ls -lh /var/www/html/wp-content/wpvividbackups"
```

Copy all files from the container backup folder to the project backup folder:

```powershell
docker cp shoalsaa-website-wordpress-1:/var/www/html/wp-content/wpvividbackups/. .\local-backups\wpvivid\
```

If the container holds old backups, use `docker cp` with the exact backup filename or copy the current complete backup set. WPvivid may split a backup into multiple ZIP archives; keep all parts together. The local `local-backups\wpvivid\` folder is excluded from Git. Backups can contain private site and database data, so do not commit or push them.

To open a shell in WordPress:

```powershell
docker compose exec wordpress sh
```

To copy an individual host file into the container's WPvivid backup directory:

```powershell
docker cp .\local-backups\wpvivid\backup.zip shoalsaa-website-wordpress-1:/var/www/html/wp-content/wpvividbackups/
```

## Restoring a WPvivid backup

1. The backup source is the dev site, <https://dev.shoalsaa.org> (test.shoalsaa.org was retired on 27 November 2026). Do not back up the live site's database or uploads for local use.
2. Start the stack and install WPvivid in the local WordPress instance if the import workflow requires it.
3. Fill in the General Settings on the dash board, especially the Site Title (shoalsaa docker test),  time-zone (Chicago), and Week Starts On (Sunday).
4. Create a fresh, complete migration backup (database and site files) on dev.shoalsaa.org following the procedure here: <https://docs.wpvivid.com/auto-migration.html>
5. Import and restore the backup. Verify the restored plugin files exist under `wp-content/plugins` and the plugin settings are present in the restored database. disable auto-update for all plugins and for wordpress - or install the Disable Updates – Updates Manager, Disable Automatic Updates, Disable All Updates plugin (long name hard to find. Shows up as Updates Manager after installation. activate it and set updates to manual for all wordpress and plugins)
6. Point SMTP at Mailpit before testing email, so test messages are captured locally.Settings: Transport: Other SMTP
Mailer Type: PostSMTP, Outgoing Mail Server Hostname: mailpit, Outgoing Mail Server Port: 1025,
Envelope-From Email Address: <webservant@shoalsaa.org>.
7. Use WPvivid's URL replacement feature, or a serialization-aware WordPress search/replace tool, to replace production URLs with `http://localhost:8080`. Update `home` and `siteurl` to that URL as well. Avoid raw SQL string replacement because serialized values can be corrupted.
8. Clear caches and test the homepage, admin login, media, plugin pages, permalinks, and email delivery.

The Compose `WP_HOME` and `WP_SITEURL` settings force WordPress to use the local URL even if the restored database initially contains production URLs. Replacing production URLs in the database is still useful for links embedded in content and plugin settings. DO NOT restore backups of the Docker image to the online test site <https://dev.shoalsaa.org> or the live site <https://www.shoalsaa.org>

## Safety notes

All credentials and salts in this stack are local-development placeholders. Do not reuse them for production or expose the local services to an untrusted network. Never bake production credentials into the image. Back up existing Docker volumes before removing or recreating them; `docker compose down -v` deletes named-volume data.
