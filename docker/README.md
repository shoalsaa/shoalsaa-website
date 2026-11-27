# Local test site (Docker)

A throwaway copy of WordPress on your own machine for testing the site-report
plugin without touching test.shoalsaa.org or the live site. The compose file
pins WordPress 7.1.5 and MySQL 8.4.11 and selects the PHP 8.4 Apache image.
Check the running PHP patch with `docker compose exec wordpress php -v` before
serious testing. The MySQL image matches upstream 8.4.11; its Ubuntu package
build suffix on the live site is distribution-specific.

The root `docker-compose.yml` is the authoritative source for the local
services, ports, database configuration, and test-only credentials. Keep
environment values there rather than maintaining separate copies in docs.

## Prerequsites

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

1. Put the plugin code in `site-report-plugin/` (it is mounted into the
   container at `wp-content/plugins/shoalsaa-site-report`).
2. In the local WP Admin: Plugins > ShoalsAA Site Report > Activate.
3. Create a test Application Password (Users > Profile) and call a REST
   route, for example in PowerShell:

```powershell
curl.exe -u "username:app-password" http://localhost:8080/wp-json/shoalsaa-report/v1/inventory
```

Compare every figure against the WP Admin screens. Revoke the test
application password when you are done.

## Notes

- This is a bare WordPress install: no site content, Burst, or WPvivid data.
  Install plugins through Plugins > Add New inside the container as needed.
- Stop with `docker compose down`. Add `-v` to wipe the database and start
  completely fresh: `docker compose down -v`. ASK for permission before doing this
- Nothing here talks to shoalsaa.org, test.shoalsaa.org, or DreamHost directly.
- Alll plugin code should meet wordpress coding standards (see <https://github.com/WordPress/WordPress-Coding-Standards/blob/develop/README.md#minimum-requirements>) Set up VSCode with the recommended plugins, actions, etc.
- Install the wordpress standards `composer config allow-plugins.dealerdirect/phpcodesniffer-composer-installer true` `composer require --dev wp-coding-standards/wpcs:"^3.0`.
