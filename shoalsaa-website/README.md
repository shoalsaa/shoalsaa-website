# ShoalsAA Site Report Plugin

This project is for a WordPress plugin that runs the reporting workflow on the
site itself:

- Send a self-contained daily email with the site's status and inventory.
- Generate and email a monthly plain-text status summary, including usage statistics.

The plugin is not built yet. Development and testing happen on the test site
first; nothing goes to the live site until it has been tested there.

## Project files

- `site-report-plugin/` — plugin source as it is built.
- `docs/site-report-plugin-design.md` — an earlier detailed design draft;
  reconcile it with the scope above before using it as a build specification.
- `local-model/build-brief.md` — the local-model working brief; update it to
  the current scope before implementation resumes.
- `docker-compose.yml` + `docker/README.md` — local WordPress test site
  (WordPress 7.1.4, PHP 8.4, MySQL 8.4). Run `docker compose up -d`, then open
  http://localhost:8080.
- `tests/` — PHPUnit + Brain Monkey unit tests. Run `composer install`, then
  `vendor/bin/phpunit`; integration checks run against the Docker stack.
- `.github/workflows/ci.yml` — CI for PHP lint, unit tests, and a Docker boot
  check on every push and pull request.

The plugin's reporting and delivery are intended to be self-contained. Earlier
integration approaches are deferred and are not part of the current scope.
