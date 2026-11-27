# Project history

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
  for merge parity. Its relative build and mount paths assume the repository
  root, so do not run the nested copy as a standalone stack before the project
  merge/consolidation is complete.
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
