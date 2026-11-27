# Build brief for a local model (Ollama)

Use this brief when asking a local coding model to build the contained
site-report plugin. The webservant reviews everything before it is
uploaded anywhere.

## Read first

`docs/site-report-plugin-design.md` — read it fully. It is the spec. This
brief turns it into build steps; where the two differ, the design document
wins.
The 20 November 2026 revision establishes the current architecture:
implement one plugin, contained entirely within WordPress, with no public
inbound endpoints. The plugin collects data internally, schedules its own
reports with WP-Cron, and sends them with `wp_mail` through Post SMTP.

The daily report is a factual inventory email sent at 08:00. The monthly
report is also plain email text, sent every Sunday only when that Sunday is
the last Sunday of the month. The first scheduled run is Sunday 29 November
2026.

Default recipient: <webservant@shoalsaa.org>. Make the recipient
configurable. Do not place any password, token, credential, or secret in
the code.

## Model choice (local environment)

This project does not require a particular model, quantization, temperature,
context size, or computer. Choose a code-capable model that fits the
implementer's available hardware when work begins. The plugin and its
acceptance criteria must not depend on this local tooling choice.

For historical reference only, Rob's current local profile (21 November
2026) is `code-specialist`, based on
`qwen2.5-coder:7b-instruct-q4_k_m`, with temperature 0.10 and a configured
4,096-token context, on a Dell XPS 8940 with a GTX 1660 Ti (6 GB VRAM).
This is an example profile, not a requirement or a guarantee that it will
remain installed or suitable. A future chair may select a different base
model and settings for their hardware.

## Prompt sizing and task chunking

There is no project-wide fixed context-window limit. Check the selected
model's actual configured context when preparing prompts. Include only the
shared requirements, task-specific design sections, relevant code, and
references needed for that task; leave room for the model's response. Use
the target model's tokenizer when available. The chunks below are a
workflow aid, not a restriction: combine or split them as appropriate for
the chosen model and task, while keeping implementation progress in files
rather than relying on chat memory.

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
- **WPvivid status scope.** “Backup status” means the Backup and Restore
  tab summary: enabled schedule, recurrence, server time, last backup
  (time and result), and next backup. It does not mean opening, validating,
  or restoring a backup archive.

## Shared constraints (every chunk)

- Read-only by design. No inbound REST or reporting endpoints and no code
  that updates, installs, activates, or changes anything on the site.
- No secrets, keys, tokens, or credentials anywhere in the code.
- All plugin PHP must meet the WordPress Coding Standards:
  <https://developer.wordpress.org/coding-standards/wordpress-coding-standards/php/>.
- Every email (daily and monthly) states the origin site's own URL at the
  top (never a hardcoded live URL). Any data source that cannot be reached
  is stated as not checked — never invent a number.
- Schedule times and report dates use the site's WordPress time zone
  (America/Chicago on the district sites), not UTC.
- Do not modify the design document.

## The chunks

Work through these in order, one chat (or one prompt) per chunk.

**Chunk 0 — skeleton and scheduling.** Plugin in `site-report-plugin/`, slug
`shoalsaa-site-report`, version 0.1.0, for WordPress 7.1.5 / PHP 8.4.27.
Main file with the plugin header, activation that does nothing but
record the version, and `readme.txt` with installation + testing notes.
Register the daily 08:00 WP-Cron event and a custom interval for the
Sunday 07:00 last-Sunday-of-the-month check, both in the site time zone. Provide admin buttons for manually triggering both
reports during development and testing.

**Chunk 1 — inventory and changes.** Internal inventory collection:
site URL,
WordPress / PHP / MySQL versions, active theme + version, all plugins
(name, version, active/inactive, auto-update status) including must-use,
and updates pending. WordPress APIs: `home_url()`, `get_bloginfo()`,
`phpversion()`, `$wpdb->db_version()`, `wp_get_theme()`,
`get_plugins()`, `get_mu_plugins()`, `wp_get_update_data()`.
Keep two inventory snapshots in separate WordPress options: a daily
snapshot and a monthly snapshot. The daily report diffs against the daily
snapshot and then replaces it; the monthly report diffs against the monthly
snapshot and then replaces it. The daily run must never overwrite the
monthly snapshot, so the monthly report shows changes from the prior month,
not the prior day. If a snapshot does not exist yet, say so in the report
and save the baseline. Report version moves and plugins added or removed. Content-edit
tracking is out of scope.

**Chunk 2 — backup status.** Collect WPvivid version, schedule (enabled,
recurrence, next backup), last backup (time, type), and last result.
Use the verified WPvivid sources above. Include the same schedule-status
fields in both the daily and monthly emails. If the last backup failed,
make it prominent notification in the daily email and retain it in the
monthly email. If Schedule Status is not Enabled, add a WARNING in both
emails. Report only the displayed schedule fields; do not validate or
restore backup archives.

**Chunk 3 — usage statistics.** Collect Burst visitors, pageviews, sessions,
and the requested/reporting date range using Burst's statistics query path.
Do not hand-roll queries against raw Burst hit tables. App for Cloudflare
reads Cloudflare analytics through its GraphQL `GetZoneAnalytics` query.
Reuse the same WordPress-hosted authentication pattern: bearer token from
`cloudflareAuth.token`, falling back to `cloudflareAuth.email` and
`cloudflareAuth.api_key`. Resolve the zone ID for the origin hostname and
query the exact reporting period. The reporting period runs from the
previous monthly report's run up to the morning of this run (first run:
from 00:00 on the first day of that month); use the same period for Burst.
If a source can only return a rolling window, report that window's dates
and say it is not the exact period. Include visitors/uniques, requests,
cached bytes/requests, total bytes, threats, and period dates. If the
credentials or API cannot be reached, state that Cloudflare was not checked.

**Chunk 4 — daily email and sending.** Assemble the daily plain-text
inventory email: origin URL at the top, inventory, changes since the daily
snapshot, updates pending, and the WPvivid backup status (with the failed-
backup notice and disabled-schedule WARNING). Write the shared sending code
used by both reports: send to the configurable recipient with `wp_mail`
(delivered by Post SMTP).

**Chunk 5 — monthly email.** Assemble the monthly plain-text status email
and send it with the Chunk 4 sending code. Include origin URL at the top,
reporting period,
inventory, changes, updates, the exact same WPvivid backup status fields
used in the daily email, Burst figures, and monthly Cloudflare figures obtained through App for Cloudflare's
GraphQL zone-analytics path. When Cloudflare cannot be reached, state
plainly that it was not checked instead of inventing or repeating an old
number.

**Chunk 6 — tests.** PHPUnit + Brain Monkey unit tests in `tests/Unit`
(see `tests/README.md`): snapshot diffing, report assembly, email content,
and scheduling logic. Run `composer install`, then `vendor/bin/phpunit`.
Check all plugin PHP against the WordPress Coding Standards with
`composer lint` (rules in `phpcs.xml.dist`); it must report no errors. Verify the
Docker stack, activation, scheduled-event registration, manual buttons,
email delivery, and both email formats.

## Deliverables

- The complete plugin in `site-report-plugin/`.
- `includes/` PHP classes.
- `readme.txt` with installation and testing notes.
- `BUILD-NOTES.md` in the plugin folder: public-source verification with
  links, every item still needing live verification, and a staged test
  checklist: Stage 1 local Docker basic integration (`docker/README.md`),
  followed only after it passes by Stage 2 data verification on
  dev.shoalsaa.org.
- A dev-site test document when one is needed, for example
  `docs/dev-site-test.md`. Keep it outside `site-report-plugin/`, because
  the deploy copies everything in that folder (except `README.md`) to the
  site.

## Test it

**Stage 1 — local Docker:** run `docker compose up -d --build` from the repo root,
open <http://localhost:8080>, activate the plugin, trigger both reports,
verify scheduling and Mailpit delivery, report structure, warnings, and
unavailable-data behavior. Do not treat local data as production data.

**Stage 2 — staging:** only after Stage 1 passes, deploy to
dev.shoalsaa.org (merge to `main`; see `docs/deploy.md`) and compare each data source and both emails against the
admin screens. Do not install on the live site without the webservant's
explicit approval.
Use `docker-compose.yml` as the source of truth for local test environment
values; do not duplicate or assume its database credentials elsewhere.
Configure local Post SMTP to use the Mailpit service on port 1025 and
inspect captured messages at <http://localhost:8025>.

## Deprecated scope

The earlier WordPress Abilities API / MCP Adapter / REST-route split is
not part of the current build. It was phased out in the 20 November 2026
design revision. Do not add public inbound reporting endpoints. If MCP or
external reporting is revisited later, treat it as a separate design and
build phase.
