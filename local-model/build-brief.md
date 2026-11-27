# Build brief for a local model (Ollama)

Use this brief when asking a local coding model to build the Phase 1
site-report plugin. The human (Rob) reviews everything before it is
uploaded anywhere.

## Read first

`docs/site-report-plugin-design.md` — read it fully. It is the spec.
Decisions already made (17 November 2026): Phase 1 only; the monthly
report is a PDF built by the plugin with TCPDF. When complete, it is atached to an email and sent to <webservant@shoalsaa.org>.
Note: make the email destination is configurable, with <webservant@shoalsaa.org> as the default value

## Build

A WordPress plugin in `site-report-plugin/`, slug `shoalsaa-site-report`,
version 0.1.0, for WordPress 7.1.4 / PHP 8.4.27:

1. Four JSON data abilities (WordPress Abilities API, each flagged public
   so the MCP Adapter exposes them): `shoalsaa-report/get-inventory`,
   `/get-burst-stats`, `/get-backup-status`, `/get-changes-since`, plus a
   plain REST namespace (e.g. `/wp-json/shoalsaa-report/v1/...`) with the
   same handlers.
2. One PDF ability: `shoalsaa-report/get-monthly-report-pdf`. Builds the
   monthly report as a PDF with TCPDF. States the origin site's own URL at
   the top (never a hardcoded live URL). For the docker hosted test site localhost: port# is acceptable.
   Accepts OPTIONAL Cloudflare figures  as input (visitors, requests, cached %, period dates); when absent, the
   PDF must state plainly that Cloudflare figures were not obtained.
3. TCPDF: bundle the plugin's OWN copy (tecnickcom/tcpdf, from its official
   source) under the plugin's `vendor/` directory. Do NOT depend on the copy
   bundled with the 12 Step Meeting PDF Generator plugin.
4. Permission callbacks must accept a dedicated low-privilege reporting user
   (e.g. Subscriber) authenticated by WordPress Application Password.
   Authentication is the gate; do NOT require administrator capabilities.
5. `get-changes-since` keeps the last inventory snapshot in a WordPress
   option and diffs on each run. Content-edit tracking is OUT of scope.
6. Burst and WPvivid sources: research both plugins' PUBLIC source
   (wordpress.org / GitHub) to find how Burst Statistics stores usage data
   and how WPvivid stores schedule / last / next backup. Where a source
   cannot be confirmed from public code, return an explicit "not available /
   not verified" marker. Never invent numbers. Never assume table or option
   names.
7. Confirm the exact public flag for abilities from the MCP Adapter
   plugin's public source (the design doc says meta.public /
   meta.mcp.public — verify which is correct for v0.7.1).

## Constraints

- Read-only by design. No write abilities, no write REST routes, no code
  that updates, installs, activates, or changes anything on the site.
- No secrets, keys, tokens, or credentials anywhere in the code.
- Do not modify the design document.
- All code must meet Wordpress Coding standards. see <https://github.com/WordPress/WordPress-Coding-Standards/tree/develop/.github>.

## Deliverables

- The complete plugin in `site-report-plugin/` (main file, includes,
  `vendor/tcpdf`, readme.txt with installation + testing notes).
- `BUILD-NOTES.md` in the plugin folder: what was verified from public
  sources (with links), every item still needing live verification, and a
  step-by-step install + test checklist for the local Docker stack
  (`docker/README.md`)
 dev.shoalsaa.org. ( 'Online-Test/Build_Online.md')


## Test it

`docker compose up -d` from the repo root, open localhost:Wordpress-docker-container-port,
activate the plugin, call each REST route with a test Application
Password, and compare every figure against the WP Admin screens.
