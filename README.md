# ShoalsAA Site Report Plugin

Code and documents for the AA District 1 (Area 1) website, shoalsaa.org.
Maintained by the District 1 Web-Committee Chair (webservant@shoalsaa.org).

This project is for a WordPress plugin that runs the site's reporting workflow
and email delivery itself:

- Send a self-contained daily email with the site's status and inventory.
- Generate and email a monthly plain-text status summary, including usage
  statistics.

The plugin is not built yet. Development and testing happen in the local
Docker site first, then on <https://dev.shoalsaa.org>; nothing goes to the
live site until it has been tested and approved.

## Project files

- `site-report-plugin/` — plugin source as it is built.
- `docs/site-report-plugin-design.md` — the design (revised 20 November 2026:
  no phasing, fully contained in the plugin, no inbound endpoints).
- `docs/todo.md` and `docs/project-history.md` — open work and what has been
  done so far.
- `local-model/build-brief.md` — the brief for building the plugin with a
  local model; `local-model/prompt-chunking.md` covers how to feed it in parts.
- `docker-compose.yml` + `docker/` — authoritative local WordPress test
  environment (WordPress 7.1.5, PHP 8.4, MySQL 8.4.11, Mailpit), including its
  ports and test-only database configuration. See `docker/README.md` for test
  instructions and `readme-Docker.md` for the setup notes.
- `tests/` — PHPUnit + Brain Monkey unit tests (run `composer install`, then
  `vendor/bin/phpunit`) and the staged integration test guidance.
- `.github/workflows/ci.yml` — CI: PHP lint, WordPress Coding Standards
  check (`composer lint`), unit tests, and a boot check of the Docker stack
  on every push and pull request.
- `.github/workflows/deploy.yml` + `docs/deploy.md` — deploys the plugin to
  DreamHost over SSH: dev automatically after CI passes on `main`, live only
  by hand with approval. See `docs/deploy.md` for the one-time setup.

The plugin's reporting and delivery are self-contained. Earlier integration
approaches (WordPress Abilities / MCP Adapter / REST routes) are deferred and
are not part of the current scope.

## Documents that do NOT live here

The website manual (v3.3, Word, with screenshots) stays in Word for now;
versioned copies live on the webservant's OneDrive. The website succession
plan covers more than the website and has its own repository.

## Ownership and succession

This repository lives in the District 1 GitHub organization (`shoalsaa`), not
in any one person's account, so it moves with the office. The organization
should always have at least two owners, so the code and documents are never
stranded with a single account.
