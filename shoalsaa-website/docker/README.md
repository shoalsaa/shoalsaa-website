# Stage 1: Local test site (Docker)

A throwaway copy of WordPress on your own machine, matching the live site's
versions (WordPress 7.1.5, PHP 8.4, MySQL 8.4), for basic integration
testing of the site-report plugin before it is installed on
test.shoalsaa.org. The local site does not contain production data, so it
cannot establish production analytics or backup figures.

## Prerequsites

- Docker Desktop installed and running.
- This repository cloned locally.

## Start it

From the repo root, in PowerShell:

```powershell
docker compose up -d
```

Then open <http://localhost:8080> and finish the WordPress install (site title,
admin user and password are all test-only — anything you like).

## Test the plugin

This is Stage 1 of the testing plan. Complete it before proceeding to
Stage 2 on `test.shoalsaa.org` as described in
`docs/site-report-plugin-design.md`.

1. Put the plugin code in `site-report-plugin/` (it is mounted into the
   container at `wp-content/plugins/shoalsaa-site-report`).
2. In the local WP Admin: Plugins > ShoalsAA Site Report > Activate.
3. Use the plugin's admin buttons to trigger the daily and monthly email
   reports.
4. Verify message delivery in Mailpit, report structure and local origin
   URL. Check scheduling, the failed-backup notification, disabled-schedule
   warning, and unavailable-data behavior.

## Notes

- This is a bare WordPress install: no site content, no Burst or WPvivid
  data. To test those data sources, install Burst Statistics and WPvivid
  Backup from Plugins > Add New inside the container first. This still does
  not substitute for checking live-like figures against the staging site.
- Stop with `docker compose down`. Add `-v` to wipe the database and start
  completely fresh: `docker compose down -v`.
- Nothing here talks to shoalsaa.org, test.shoalsaa.org, or DreamHost.
