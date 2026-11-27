# ShoalsAA Site Report Plugin

This project is for a WordPress plugin that runs the site's reporting workflow
and email delivery itself:

- Send a self-contained daily email with the site's status and inventory.
- Generate and email a monthly status summary, including usage statistics.

The plugin is not built yet. Development and testing happen in the local
WordPress environment first; nothing goes to the live site until it has been
tested and approved.

## Project files

- `site-report-plugin/` — plugin source as it is built.
- `docker-compose.yml` — authoritative local WordPress test environment,
  including its ports and test-only database configuration. See
  `docker/README.md` for test instructions.
- `tests/` — PHPUnit unit tests and test guidance.

The current scope is the plugin's self-contained daily and monthly email
reports.
