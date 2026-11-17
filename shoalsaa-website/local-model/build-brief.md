# Build brief for a local model (Ollama)

Use this brief when asking a local coding model to build the Phase 1
site-report plugin. The human (Rob) reviews everything before it is
uploaded anywhere.

## Which model

`code-specialist` — Qwen2.5-Coder 7B instruct, Q4_K_M, temperature 0.10
(see `Ollama_Model_Optimization_Guide.md`: Dell XPS 8940, GTX 1660 Ti,
6 GB VRAM).

## The one rule that shapes everything: 4,096-token context

The model's context window is 4,096 tokens. The design document
(`docs/site-report-plugin-design.md`) is about 27 KB — roughly 7,000
tokens — so it will NOT fit alongside a task and the code to write.
Do not paste the whole design document into one prompt. Work in the
small chunks below, pasting only the slice each chunk needs, and keep
each prompt short. If a reply starts repeating itself or losing the
thread, stop, start a fresh chat, and continue from the next chunk.

## Verified data sources (already researched — do not re-research)

Checked 17 November 2026 against the public plugin sources
(Burst Statistics 3.7.5, WPvivid Backup 0.9.140):

- **Burst usage.** Raw hits live in `{prefix}burst_statistics` (one row
  per hit, updated by `update_statistic()` in
  `includes/Frontend/Tracking/class-tracking.php`). Visitors, pageviews
  and sessions for a date range are COMPUTED, not stored — Burst's own
  query builder in `includes/Admin/Statistics/class-statistics-data.php`
  aggregates with `date_range($start, $end)`. Do not hand-roll SQL against
  the table assuming a schema: use Burst's statistics query path, and
  check the result against the Burst statistics page figure for figure.
  Supporting tables: `burst_sessions`, `burst_daily`, `burst_page_urls`.
- **WPvivid schedule.** `get_option('wpvivid_schedule_setting')` gives the
  `backup` sub-array (`backup_files`, `local`, `remote`, `ismerge`,
  `lock`). Enabled / recurrence / next backup are derived live:
  `WPvivid_Schedule::get_schedule_ex()` in
  `includes/class-wpvivid-schedule.php` uses
  `wp_get_schedule(WPVIVID_MAIN_SCHEDULE_EVENT)` and
  `wp_next_scheduled(WPVIVID_MAIN_SCHEDULE_EVENT)`. Call
  `WPvivid_Schedule::get_schedule()` if the class is loaded, or replicate
  those two calls.
- **WPvivid backup list.** `get_option('wpvivid_backup_list')`, entries
  keyed by id, each with `type` (Manual / Cron / Migration / Upload /
  Rollback), `create_time`, and files with `size`. Whether each entry
  carries its own result status needs a live check against the WPvivid
  page — if it does not, say so rather than guessing.
- **MCP Adapter flag.** Confirm the exact public flag for abilities from
  the MCP Adapter plugin's public source (the design doc says meta.public
  / meta.mcp.public — verify which is correct for v0.7.1).

## Shared constraints (every chunk)

- Read-only by design. No write abilities, no write REST routes, no code
  that updates, installs, activates, or changes anything on the site.
- No secrets, keys, tokens, or credentials anywhere in the code.
- TCPDF: bundle the plugin's OWN copy (tecnickcom/tcpdf, from its
  official source) under the plugin's `vendor/` directory. Do NOT depend
  on the copy bundled with the 12 Step Meeting PDF Generator plugin.
- The monthly PDF states the origin site's own URL at the top (never a
  hardcoded live URL). Any data source that cannot be reached is stated
  as not checked — never invent a number.
- Do not modify the design document.

## The chunks

Work through these in order, one chat (or one prompt) per chunk.

**Chunk 0 — skeleton.** Plugin in `site-report-plugin/`, slug
`shoalsaa-site-report`, version 0.1.0, for WordPress 7.1.4 / PHP 8.4.
Main file with the plugin header, activation that does nothing but
record the version, and `readme.txt` with installation + testing notes.

**Chunk 1 — inventory.** Ability `shoalsaa-report/get-inventory` plus
REST route `/wp-json/shoalsaa-report/v1/inventory`: site URL,
WordPress / PHP / MySQL versions, active theme + version, all plugins
(name, version, active/inactive, auto-update status) including must-use,
and updates pending. WordPress APIs: `home_url()`, `get_bloginfo()`,
`phpversion()`, `$wpdb->db_version()`, `wp_get_theme()`,
`get_plugins()`, `get_mu_plugins()`, `wp_get_update_data()`.
Permission callback: accept any authenticated user (authentication by
Application Password is the gate; do NOT require administrator
capabilities, so a low-privilege reporting user works).

**Chunk 2 — backup status.** Ability `shoalsaa-report/get-backup-status`
plus REST route: WPvivid version, schedule (enabled, recurrence, next
backup), last backup (time, type) and last result. Use the verified
WPvivid sources above.

**Chunk 3 — Burst stats.** Ability `shoalsaa-report/get-burst-stats`
plus REST route: visitors, pageviews, sessions for a requested date
range (start/end as input). Use the verified Burst sources above.

**Chunk 4 — changes since.** Ability `shoalsaa-report/get-changes-since`
plus REST route: keep the last inventory snapshot in a WordPress
option, diff on each run, report version moves and plugins
added/removed. Content-edit tracking is OUT of scope.

**Chunk 5 — monthly PDF.** Ability `shoalsaa-report/get-monthly-report-pdf`:
builds the monthly report as a PDF with TCPDF from the data the other
abilities return. Accepts OPTIONAL Cloudflare figures as input
(visitors, requests, cached %, period dates); when absent, the PDF must
state plainly that Cloudflare figures were not obtained.

**Chunk 6 — tests.** PHPUnit + Brain Monkey unit tests in `tests/Unit`
(see `tests/README.md`): snapshot diffing, report assembly, PDF content.
Run `composer install`, then `vendor/bin/phpunit`.

## Deliverables

- The complete plugin in `site-report-plugin/`.
- `BUILD-NOTES.md` in the plugin folder: what was verified, every item
  still needing live verification, and a step-by-step install + test
  checklist for the local Docker stack (`docker/README.md`) and then
  test.shoalsaa.org.

## Test it

`docker compose up -d` from the repo root, open http://localhost:8080,
activate the plugin, call each REST route with a test Application
Password, and compare every figure against the WP Admin screens.
