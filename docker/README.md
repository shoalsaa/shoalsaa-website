# Stage 1: Local test site (Docker)

A throwaway copy of WordPress on your own machine for basic integration
testing of the site-report plugin before it is deployed to dev.shoalsaa.org,
without touching dev or the live site. The compose file pins WordPress 7.1.5
and MySQL 8.4.11 and selects the PHP 8.4 Apache image. Check the running PHP
patch with `docker compose exec wordpress php -v` before serious testing. The
MySQL image matches upstream 8.4.11; its Ubuntu package build suffix on the
live site is distribution-specific.

The root `docker-compose.yml` is the authoritative source for the local
services, ports, database configuration, and test-only credentials. Keep
environment values there rather than maintaining separate copies in docs.
Setup notes and the WPvivid restore procedure are in `readme-Docker.md`.

## Prerequisites

- Docker Desktop installed and running.
- This repository cloned locally.

## Start it

From the repo root, in PowerShell:

```powershell
docker compose up -d
```

Then open http://localhost:8080 and finish the WordPress install (site title,
admin user and password are test-only — choose values for this local install).

Install Post SMTP in the local WordPress site and configure its SMTP host as
`mailpit`, port `1025`, with no authentication or encryption. This uses the
internal Docker service and avoids the real SMTP relay. Configure this before
testing email; the Mailpit container by itself does not redirect WordPress
mail. Open http://localhost:8025 to view captured messages.

The database uses a fresh `mysql_data` volume. Any older MariaDB volume is
left untouched.

## Test the plugin

This is Stage 1 of the testing plan. Complete it before Stage 2 on
`dev.shoalsaa.org`, as described in `docs/site-report-plugin-design.md` §8.

1. Put the plugin code in `site-report-plugin/` (it is mounted into the
   container at `wp-content/plugins/shoalsaa-site-report`, so edits are live).
2. In the local WP Admin: Plugins > ShoalsAA Site Report > Activate.
3. Use the plugin's admin buttons to trigger the daily and monthly email
   reports.
4. Verify message delivery in Mailpit, report structure and local origin
   URL. Check scheduling, the failed-backup notification, disabled-schedule
   warning, and unavailable-data behavior.

## Notes

- A bare install has no site content, Burst, or WPvivid data. Either install
  Burst Statistics and WPvivid Backup from Plugins > Add New, or restore a
  WPvivid migrate backup of dev.shoalsaa.org (see `readme-Docker.md`). A
  restored copy holds real users, form entries and mail settings: keep backup
  files in `local-backups/` (git-ignored), never commit them, and point Post
  SMTP at Mailpit before any test run. Local figures are still not production
  figures.
- Stop with `docker compose down`. Add `-v` to wipe the database and start
  completely fresh: `docker compose down -v`. ASK for permission before doing this.
- Nothing here talks to shoalsaa.org, dev.shoalsaa.org, or DreamHost directly.
- All plugin code should meet the WordPress coding standards (see <https://github.com/WordPress/WordPress-Coding-Standards/blob/develop/README.md#minimum-requirements>). Set up VS Code with the recommended extensions (`.vscode/extensions.json`).
- Install the WordPress standards: `composer config allow-plugins.dealerdirect/phpcodesniffer-composer-installer true` then `composer require --dev wp-coding-standards/wpcs:"^3.0"`.
