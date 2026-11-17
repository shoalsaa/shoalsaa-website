# Local test site (Docker)

A throwaway copy of WordPress on your own machine, matching the live site's
versions (WordPress 7.1.4, PHP 8.4, MySQL 8.4), for testing the site-report
plugin without touching test.shoalsaa.org or the live site.

## Prerequsites

- Docker Desktop installed and running.
- This repository cloned locally.

## Start it

From the repo root, in PowerShell:

```powershell
docker compose up -d
```

Then open http://localhost:8080 and finish the WordPress install (site title,
admin user and password are all test-only — anything you like).

## Test the plugin

1. Put the plugin code in `site-report-plugin/` (it is mounted into the
   container at `wp-content/plugins/shoalsaa-site-report`).
2. In the local WP Admin: Plugins > ShoalsAA Site Report > Activate.
3. Install the MCP Adapter plugin (0.7.1) from Plugins > Add New if you want
   to test the MCP endpoint.
4. Create a test Application Password (Users > Profile) and call a REST
   route, for example in PowerShell:

```powershell
curl.exe -u "username:app-password" http://localhost:8080/wp-json/shoalsaa-report/v1/inventory
```

Compare every figure against the WP Admin screens. Revoke the test
application password when you are done.

## Notes

- This is a bare WordPress install: no site content, no Burst or WPvivid
  data. To test those data sources, install Burst Statistics and WPvivid
  Backup from Plugins > Add New inside the container first.
- Stop with `docker compose down`. Add `-v` to wipe the database and start
  completely fresh: `docker compose down -v`.
- Nothing here talks to shoalsaa.org, test.shoalsaa.org, or DreamHost.
