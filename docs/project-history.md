# Project history

## 2026-11-27

- Folded the nested `shoalsaa-website/` folder into the top level and
  deleted it (commit `834a235`). Test target changed from test.shoalsaa.org
  to dev.shoalsaa.org; added the DreamHost deploy workflow
  (`docs/deploy.md`).
- Reviewed the repository for conflicting instructions; findings and
  recommendations are in `docs/claude-status.md`.
- PR #4: ignore `/vendor/` and commit `composer.lock`.
- PR #5: recipient typo fixed; "Branching and merge" rule (merge to `main`
  only after Stage 1); dev is the single backup source for local restores;
  separate daily and monthly inventory snapshots.
- Design decisions recorded in the design doc: it is the build
  specification; monthly usage covers an exact reporting period; schedules
  use the site time zone (America/Chicago); "read-only" means the plugin
  writes only its own options and WP-Cron events; live approval belongs to
  the webservant office. Retired nested-folder notes moved to
  `docs/archive/`.
- Rob verified that the dev admin password differs from the local Docker
  one, and that the WordPress time zone is America/Chicago on dev and live.
- PR #7: WordPress Coding Standards check (`composer lint`) in Composer and
  CI.
- Docker docs cleanup: one start command (`docker compose up -d --build`);
  Mailpit pinned to v1.34.0 and PHP to 8.4.27 (matching live; the local
  container had drifted to 8.4.28 on the floating tag); `readme-Docker.md`
  reduced to a how-to, with its conversation record moved to the end of this
  file; `docs/README.md` is now an index; `prompt-chunking.md` rewritten as
  guidance; the performance notes are labelled as live-site operations
  notes.

## 2026-11-22

- Worked with Docker Desktop's Gordon AI to create a project-specific local
  WordPress environment. Gordon was given the site and DreamHost details
  supplied by Rob as construction requirements; the session and setup notes
  are in the root `readme-Docker.md`.
- The resulting root `docker-compose.yml` builds WordPress 7.1.5 on PHP 8.4,
  runs MySQL 8.4.11 and Mailpit, persists WordPress and database files, and
  exposes WordPress at `http://localhost:8080` and Mailpit at
  `http://localhost:8025`. The root Docker configuration is the one currently
  applied and is the source of truth.
- The previous application occupying port 8080 was removed and Windows was
  restarted. The Docker WordPress service now owns the port; a local request
  returned HTTP 200 and showed the WordPress installation screen. MySQL and
  Mailpit were healthy when checked.
- Synchronized the nested `docker-compose.yml` with the root configuration
  for merge parity. (Superseded: the nested folder was removed on
  27 November 2026.)
- The test site backup has not yet been added. Store the working copy under
  the root `local-backups/wpvivid/` directory, which is excluded from Git;
  never stage or publish the backup.

## 2026-11-21

- Resolved the monthly report format: it will be a plain-text email like the
  daily report, rather than a PDF. This removes TCPDF and dependency on the
  12 Step Meeting PDF Generator plugin.
- Resolved Cloudflare reporting for this build: App for Cloudflare stores
  authentication at `cloudflareAuth.token` (or email/API-key fallback) and
  retrieves exact-period zone statistics through its `GetZoneAnalytics`
  GraphQL query. The report plugin will use the same credentials and API
  pattern, and will state when Cloudflare could not be checked.
- Added the WPvivid reporting rule: both daily and monthly emails include
  the same Backup Schedule status fields. A failed last backup receives
  prompt notification in the daily email, and a disabled schedule is a
  WARNING in both reports.
- Clarified that model and hardware choices are not project requirements.
  The local build brief records the current Ollama profile only as a dated
  example; future maintainers can select a suitable model for their own
  hardware and update prompt budgets accordingly.
- Reworked the testing plan into two gates: basic integration on the local
  Docker site, then data verification on `test.shoalsaa.org`. The live site
  remains out of scope without explicit approval.
- Checked local port 8080: it is held by MiniTool ShadowMaker's
  `MTAgentService`, and HTTP requests time out. Docker Desktop was not
  running, so the project site could not be tested. Added a TODO to recheck
  port 8080 after MiniTool is uninstalled and Windows restarted; retain the
  current Compose port workaround until then.
- End-of-day merge status: the nested design/build/test documents now
  reflect the agreed report behavior, but the root and nested Compose/CI
  copies still differ. Do not replace root configuration wholesale before
  reconciling those differences and deciding how to preserve the existing
  Docker database volume. See `docs/todo.md` for remaining work.

## 2026-11-20

- Separated the website succession plan from the ShoalsAA site-report plugin
  project into a documentation-only local project at
  `D:\Github_projects\Website-succession-plan`. The plan and project status
  were committed locally; publishing to GitHub was deferred.
- Simplified the ShoalsAA project README to describe the plugin's
  self-contained daily status email and monthly status summary with usage
  statistics.
- Replaced the root Docker Compose configuration with a proposal targeting
  WordPress 7.1.5, MySQL 8.4.11, and Mailpit. The new configuration uses a
  separate `mysql_data` volume; Compose syntax validation passed.
- Documented that local Post SMTP should send to Mailpit (`mailpit:1025`).
  Removed the custom `local-mailpit.php` override so local testing can use the
  same mail plugin as the site.
- Updated the root Docker guide, build brief, and CI port check to use the root
  Compose configuration as the source for local environment settings.
- **Database follow-up:** the existing `shoalsaa-website_db_data` volume is
  attached to the running `shoalsaa-website-db-1` container (`mysql:8.4`). It
  was not deleted or changed. The new Compose configuration has not been
  applied; determine whether the existing database contents are needed before
  changing or rebuilding the environment.
- Rob revised `docs/site-report-plugin-design.md` to describe the current
  self-contained reporting project. Review found remaining old browser/MCP
  references, conflicting schedule and WordPress-version values, and wording
  to clarify around outbound email. The document was not edited during review.
  The VS Code Problems check returned no diagnostics; two suspicious URL
  spellings were noted in `docs/todo.md` for follow-up.
- The latest design revision removed the old browser-report history and
  resolved the reported Markdown issue. Rob clarified that the meeting-schedule
  PDF plugin is used manually only when the schedule changes; he is considering
  a Word document or email instead of PDF for the monthly report, which will be
  printed for district officers and committee chairs. The format and delivery
  details remain undecided and are tracked in `docs/todo.md`.

## 2026-11-19

- An earlier Docker Compose version (commit `ce7cbd5`) included
  `phpmyadmin:5`, available at `http://localhost:8081`, alongside MariaDB and
  WordPress. It set phpMyAdmin's `UPLOAD_LIMIT` to `64M`. The recorded history
  does not explain why that upload limit was chosen; it may have been intended
  for browser-based database imports, but that is unconfirmed.
- The current Compose setup omits phpMyAdmin. Keep the earlier configuration
  as a reference if a database administration or import UI is useful later;
  treat it as a future option, not a current requirement.

## Local Docker setup record (19–22 November 2026)

Moved here from `readme-Docker.md` on 27 November 2026, so that file can be
a short how-to. Condensed from the original user/assistant conversation.

1. **Pull failure.** Docker returned an `EOF` from
   `production.cloudfront.docker.com` while downloading
   `wordpress:7.1.4-php8.4-apache`. Retrying fixed it for WordPress and then
   MySQL: transient layer-download failures, not a Compose problem.
2. **Port 8080.** Host port 8080 was held by MiniTool ShadowMaker's
   `MTAgentService`, so the host mapping was temporarily changed to
   `8081:80`. After MTAgentService was removed and Windows restarted, the
   stack moved back to 8080.
3. **Approach for a copy of the live site.** Restore a site copy with its
   database and `wp-content`; persist database and WordPress files; route
   SMTP to Mailpit (`mailpit:1025`) and expose its UI; check
   production-dependent plugins and credentials. Production URLs must be
   replaced with a serialization-aware tool, not raw SQL, and `home` and
   `siteurl` must point to the local URL.
4. **Versions and uploads.** A WPvivid restore from shoalsaa.org to
   test.shoalsaa.org had worked well. Requested: WordPress 7.1.5 on PHP 8.4,
   with upload limits for WPvivid archives (largest observed 204032 KB).
   The official image had a WordPress 7.1.5 tag for PHP 8.3 but not PHP 8.4,
   so the Dockerfile takes WordPress core from the official 7.1.5 image and
   runs it on the PHP 8.4 Apache image. Ubuntu 26.04.1 LTS was given as the
   server platform; the local host is Windows, and the Debian-based PHP
   container is independent of either. A named volume hid the core files
   baked into the image, so a custom entrypoint now fills an empty volume
   from the pinned core and copies the custom `wp-config.php`.
5. **Gordon AI configuration.** Docker Desktop's Gordon AI was given
   project details from shoalsaa.org and DreamHost; the resulting root
   `docker-compose.yml` was confirmed as the configuration in use. (The
   nested copy it was synchronized with was deleted on 27 November 2026.)
   The stack ran on `localhost:8080` and returned HTTP 200.
6. **Incomplete WPvivid restore.** After initial setup, WPvivid was
   installed, connected to the normal Dropbox backup location, and a restore
   started. The progress display timed out at about 86% and the browser
   lost the session. All three containers stayed up (no restarts, no OOM,
   MySQL healthy); the WordPress log showed repeated HTTP 503s during
   WPvivid AJAX/admin requests. The restore log stopped at SQL offset
   31,459,533 with no completion entry; the database held 229 tables with the
   temporary `tmpbfed4d_` prefix and only 13 `wp_` tables. The restore was
   incomplete; no root cause for the 503s was found. Advice: keep the
   volumes, save a database dump before another restore, never use
   `docker compose down -v` while recovering, and enable PHP error logging
   before retrying.
7. **Local admin account.** Compose environment variables and
   `docker/wordpress-entrypoint.sh` now create the `districtone`
   administrator once, only when WordPress is not yet installed.
   Troubleshooting fixed CRLF line endings in the entrypoint and a volume
   missing `wp-config.php` (the entrypoint now copies it whenever it is
   missing). Verified: `districtone` exists, the configured password
   matches, and `/wp-login.php` returned HTTP 200. Bootstrap never resets
   credentials on an already-installed site.
