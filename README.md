# ShoalsAA Website

Code and documents for the AA District 1 (Area 1) website, shoalsaa.org.
Maintained by the District 1 Web-Committee Chair (webservant@shoalsaa.org).

## What lives here

- `docs/site-report-plugin-design.md` — design for the read-only site-report
  plugin that will feed the daily inventory email and the monthly status
  report (first pass, 15 November 2026; Phase 1 and the monthly PDF decided
  17 November 2026). The plugin itself is not built yet.
- `site-report-plugin/` — the plugin source, once it is built. Test-site first;
  nothing goes on the live site until the webservant has tested it there.
- `docker-compose.yml` + `docker/README.md` — a local WordPress test site
  (WordPress 7.1.4, PHP 8.4, MySQL 8.4) for testing the plugin on your own
  machine. `docker compose up -d`, then http://localhost:8080.
- `tests/` — PHPUnit + Brain Monkey unit tests (run `composer install`,
  then `vendor/bin/phpunit`); integration checks run against the Docker
  stack. See `tests/README.md`.
- `local-model/build-brief.md` — the brief for building the plugin with a
  local model (Ollama). The human reviews everything before upload.
- `.github/workflows/ci.yml` — CI: PHP lint, unit tests, and a boot check
  of the Docker stack on every push and pull request.
- `.github/workflows/deploy.yml` + `docs/deploy.md` — deploys the plugin to
  DreamHost over SSH: dev automatically after CI passes on `main`, live only
  by hand with approval. See `docs/deploy.md` for the one-time setup.

## Documents that do NOT live here (yet)

The website manual (v3.3, Word, with screenshots) stays in Word for now;
versioned copies live on the webservant's OneDrive. The password-manager
comparison is a PDF. If either is converted to Markdown, it moves here.

## Ownership and succession

This repository lives in the District 1 GitHub organization (`shoalsaa`), not
in any one person's account, so it moves with the office. The organization
should always have at least two owners, so the code and documents are never
stranded with a single account.
