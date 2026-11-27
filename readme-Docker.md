# ShoalsAA local WordPress: setup and restore

How to run, manage and restore the local Docker copy of the ShoalsAA site.
For plugin testing (Stage 1), see `docker/README.md`. The history of how
this setup was built is in `docs/project-history.md` ("Local Docker setup
record").

## Files and behavior

- `docker-compose.yml` runs MySQL 8.4.11, WordPress, and Mailpit v1.34.0.
  It is the source of truth for ports, database settings and the local-only
  credentials.
- WordPress is available at `http://localhost:8080`.
- Mailpit's web inbox is available at `http://localhost:8025`; SMTP inside
  the Compose network is `mailpit:1025`.
- `docker/Dockerfile` combines WordPress 7.1.5 core with PHP 8.4.27 Apache
  and the required PHP extensions.
- `docker/wordpress-entrypoint.sh` fills an empty persistent volume with the
  pinned core and the local `wp-config.php`, and on a fresh database
  installs WordPress with the `districtone` administrator.
- `docker/php.ini` allows 512 MB individual uploads and a 550 MB POST body,
  with longer request timeouts. This exceeds the largest observed WPvivid
  archive (204032 KB).
- `wordpress_data` persists WordPress files; `mysql_data` persists the
  database.
- The local `site-report-plugin/` folder is mounted into the plugin
  directory.
- `docker/wp-config.php` uses Compose environment values and points
  WordPress at `http://localhost:8080`.
- Place the local working copy of a WPvivid backup in
  `local-backups\wpvivid\`. The repository `.gitignore` excludes this
  folder; never add backup archives to Git or push them.

## Start and validate

From the repository root:

```powershell
docker compose up -d --build
docker compose ps
```

`--build` builds the local WordPress image when needed. To refresh the base
images first, run `docker compose build --pull`.

Then open `http://localhost:8080` and `http://localhost:8025`. Set the
site's SMTP plugin to host `mailpit`, port `1025`, with no TLS or
authentication for this isolated local network. Send a test message and
verify it appears in Mailpit.

## Managing files and copying WPvivid backups

Use Windows File Explorer or VS Code to browse and edit files that are in
the project folder. WordPress's full filesystem is stored in the Docker
named volume `wordpress_data`, so it does not show up as an ordinary
project subfolder. Use `docker compose exec` to inspect the container, and
`docker cp` to copy files between the container and the host.

From PowerShell, at the repository root, create the local backup folder and
list WPvivid's backup files:

```powershell
New-Item -ItemType Directory -Force .\local-backups\wpvivid
docker compose exec wordpress sh -c "ls -lh /var/www/html/wp-content/wpvividbackups"
```

Copy all files from the container backup folder to the project backup
folder:

```powershell
docker cp shoalsaa-website-wordpress-1:/var/www/html/wp-content/wpvividbackups/. .\local-backups\wpvivid\
```

If the container holds old backups, use `docker cp` with the exact backup
filename or copy the current complete backup set. WPvivid may split a
backup into multiple ZIP archives; keep all parts together. Backups can
contain private site and database data, so do not commit or push them.

To open a shell in WordPress:

```powershell
docker compose exec wordpress sh
```

To copy an individual host file into the container's WPvivid backup
directory:

```powershell
docker cp .\local-backups\wpvivid\backup.zip shoalsaa-website-wordpress-1:/var/www/html/wp-content/wpvividbackups/
```

## Restoring a WPvivid backup

Before restoring over an existing local site, save a database dump. If a
restore fails partway, keep the volumes and do not run
`docker compose down -v` while recovering.

1. The backup source is the dev site, <https://dev.shoalsaa.org>
   (test.shoalsaa.org was retired on 27 November 2026). Do not back up the
   live site's database or uploads for local use.
2. Start the stack and install WPvivid in the local WordPress instance if
   the import workflow requires it.
3. Check the General Settings: the automatic install sets the Site Title to
   "ShoalsAA Local Test". Set the time zone to Chicago (America/Chicago,
   matching dev and live) and Week Starts On to Sunday.
4. Create a fresh, complete migration backup (database and site files) on
   dev.shoalsaa.org following the procedure here:
   <https://docs.wpvivid.com/auto-migration.html>
5. Import and restore the backup. Verify the restored plugin files exist
   under `wp-content/plugins` and the plugin settings are present in the
   restored database. Disable auto-updates for all plugins and for
   WordPress, or install the "Disable Updates – Updates Manager, Disable
   Automatic Updates, Disable All Updates" plugin (it shows up as Updates
   Manager after installation), activate it, and set updates to manual for
   WordPress and all plugins.
6. Point SMTP at Mailpit before testing email, so test messages are
   captured locally. Post SMTP settings: Transport: Other SMTP; Mailer Type:
   PostSMTP; Outgoing Mail Server Hostname: `mailpit`; Outgoing Mail Server
   Port: `1025`; Envelope-From Email Address: <webservant@shoalsaa.org>.
7. Use WPvivid's URL replacement feature, or a serialization-aware
   WordPress search/replace tool, to replace production URLs with
   `http://localhost:8080`. Update `home` and `siteurl` to that URL as well.
   Avoid raw SQL string replacement because serialized values can be
   corrupted.
8. Clear caches and test the homepage, admin login, media, plugin pages,
   permalinks, and email delivery.

The Compose `WP_HOME` and `WP_SITEURL` settings force WordPress to use the
local URL even if the restored database initially contains production URLs.
Replacing production URLs in the database is still useful for links
embedded in content and plugin settings.

**Do not** restore backups of the Docker site to the online test site
<https://dev.shoalsaa.org> or the live site <https://www.shoalsaa.org>.

A restored site keeps its own users and passwords; the `districtone`
bootstrap runs only on a fresh, uninstalled database.

## Safety notes

All credentials and salts in this stack are local-development
placeholders. Do not reuse them for production or expose the local services
to an untrusted network. Never bake production credentials into the image.
Back up existing Docker volumes before removing or recreating them;
`docker compose down -v` deletes named-volume data.
