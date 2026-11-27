# ShoalsAA Site Report Plugin

Design Document

District 1, Area 1 AA — shoalsaa.org

15 November 2026 — Prepared for Rob, District 1 Web-Committee Chair
20 November 2026 -- revised, eliminate phasing, implement as totally contained in the plugin,no inbound endpoints exposed to the outside world.
27 November 2026 -- test target changed to <https://dev.shoalsaa.org> (replacing test.shoalsaa.org); plugin files reach it through the automated deploy in `docs/deploy.md`.
27 November 2026 -- no phase 2 plan, just a plugin for the website to generate 2 reports and email them on a schedule to <webservant@shoalsaa.org>
27 November 2026 -- this document is now the build specification; monthly usage covers an exact reporting period; schedule times use the site time zone; "read-only" defined (§7); approvals belong to the webservant office; §2 Scope added.
Status: build specification. `local-model/build-brief.md` turns it into build steps; where the two differ, this document wins.

## 1. Purpose

**Daily inventory email.** runs daily at 08:00 and emails a short factual inventory to <webservant@shoalsaa.org> — WordPress / PHP / MySQL / theme / plugin versions, what changed since the previous day, updates pending, and the WPvivid backup schedule status. The same backup status is included in the monthly report. A failed last backup prompts immediate attention; a disabled backup schedule is a warning in both reports. No manual updates and no WPvivid archive or restore verification.

**Monthly status report.** Fires every Sunday at 07:00 and runs only on the last Sunday of the month (first real run: Sunday 29 November 2026). A brief plain-text email to <webservant@shoalsaa.org> contains Cloudflare and Burst usage for the reporting period, changes and updates from the prior month, current versions, and the same WPvivid backup schedule status included in the daily report.

- **Reporting period.** Monthly Cloudflare and Burst figures cover an exact period: from the previous monthly report's run up to the morning of this run (for the first run, from 00:00 on the first day of that month). The report states the start and end dates. Figures need not be exact to the minute or visit. If a source can only return a rolling window, the report gives that window's dates and says plainly that it is not the exact period.

- **Time zone.** All schedule times (08:00 daily, 07:00 Sunday) and report dates use the site's WordPress time zone (Settings → General), America/Chicago on the district sites.

- Every report states the origin site's own URL at the top, so the recipient can tell which site sent it — live: <https://www.shoalsaa.org>; test: <https://dev.shoalsaa.org>. The URL is that of the site the report was generated from, never a hardcoded live-site URL.

- Reports go to <webservant@shoalsaa.org>, the district webservant mailbox, which is meant to move with the office when it changes hands — not to any individual's personal email.

## 2. Scope

In scope: one self-contained WordPress plugin that collects the data in §4, builds the daily and monthly plain-text emails, and sends them on its own WP-Cron schedule.

Out of scope:

- Changes to site pages or other content edits.
- PDF, Word, or other attachments. The monthly report is plain email text, like the daily report; no attachment or PDF library is needed.
- Inbound endpoints of any kind: no REST routes, WordPress Abilities, or MCP Adapter integration. If external reporting is revisited, it is a separate design.
- Installing, updating, activating, or configuring anything on the site (see "Read-only" in §7).
- Verifying or restoring WPvivid backup archives.

## 3. Architecture at a glance

[Site Report plugin on shoalsaa.org]  →  [WP-Cron]  →  [wp_mail via Post SMTP]  → <webservant@shoalsaa.org>

The plugin collects data from within WordPress, builds the daily and monthly plain-text emails, and mails the result to <webservant@shoalsaa.org>.

## 4. What the plugin collects

Every item below is data the reports are expected to contain is read from inside WordPress instead of from WP Admin screens. The WordPress source column names the API the plugin will use; where the source is not yet confirmed on the test site, the table says so — the build must verify those rows before relying on them.

| Data the reports need | WordPress source | Notes |
| --- | --- | --- |
| Site identity (site URL) | home_url() / site_url() | Printed at the top of every report, so the recipient can tell which site sent it. Live site: <https://www.shoalsaa.org>. |
| WordPress version | get_bloginfo('version') | Currently 7.1.5. |
| PHP version | phpversion() | Currently 8.4.27. |
| MySQL / server version | $wpdb->db_version() | Currently 8.4.11. |
| Active theme and version | wp_get_theme() | Kadence Child 1.0.0. |
| All plugins: name, version, active/inactive, auto-update status | get_plugins(), is_plugin_active(), 'auto_update_plugins' option; get_mu_plugins() for must-use | 14 regular plugins (13 active, 1 inactive) plus must-use Burst REST API Optimizer 1.3.0, as of 15 Nov 2026. |
| Updates pending (core, plugins, themes) | wp_get_update_data() / update transients | Counts and available versions; empty when nothing is pending. |
| Burst usage (visitors, pageviews, sessions, top pages, date range) | Burst's own database tables or REST endpoints — TO BE VERIFIED on the test site | Burst 3.7.5. Exact period (e.g. 16 Oct–15 Nov 2026: 354 visitors, 902 pageviews, 570 sessions) comes from the Burst statistics page today; the plugin must find the same data at its source. Do not assume table names — confirm during the build. |
| WPvivid backup status (version, schedule, last/next backup, last result) | WPvivid's stored options — TO BE VERIFIED on the test site <https://dev.shoalsaa.org>. | WPvivid 0.9.140. Backup Schedule is Enabled; server time, recurrence, last backup 13 Nov 2026 14:50 (Succeeded), and next backup Monday 30 Nov 2026 00:02 are included in both reports without archive or restore verification. A failed last result is prominent notification in the daily report and remains in the monthly report. A disabled schedule is labeled WARNING in both reports. Confirm the option names during the build. |
| Changes since last report (version moves, plugins added/removed) | Two plugin-kept snapshots (WordPress options): a daily snapshot and a monthly snapshot | The daily report diffs against the daily snapshot, then replaces it. The monthly report diffs against the monthly snapshot (saved by the previous monthly report), then replaces it; the daily run never touches the monthly snapshot, so the monthly diff covers the whole month. When a snapshot does not exist yet (first run), the report says no earlier snapshot was available and saves the baseline. A manual (admin-button) run uses the same snapshot as its scheduled report. This replaces the external changes log for version changes. |
| Cloudflare usage | App for Cloudflare stored authentication and Cloudflare GraphQL API | Reuse the same WordPress-hosted credentials and zone/hostname lookup used by App for Cloudflare: bearer token at `cloudflareAuth.token`, or email/API-key fallback. Query `GetZoneAnalytics` with the exact reporting period and include unique visitors, requests, cached requests/bytes, bytes, threats, and period dates. If credentials or the API cannot be reached, report Cloudflare as not checked rather than inventing values. |

## 5. Scheduling

 WP-Cron email from the plugin itself. The plugin should register its own WP-Cron events and email the report with wp_mail (Post SMTP is already installed and handles delivery). Three caveats, all already accepted in principle:

- By default, WordPress checks for due WP-Cron events during site requests, so a report event may run late—often after the next request. More reliable timing requires a server or hosting cron.

- WordPress has no built-in monthly interval. The plugin registers a custom interval and checks for the last Sunday itself.

- Schedule times are in the site's WordPress time zone (§1), not UTC. Schedule events from local times, so the 08:00 and 07:00 runs do not shift by an hour when daylight saving time starts or ends.

- Provide buttons on the plugin admin page for triggering each report, will need these during development and testing.

## 6. Email content

- Every report states the origin site's own URL at the top — the URL of the site the report was generated from, not always the live site — so the recipient can tell whether it is a test-site report or a live report (decided 15 November 2026).

- Numbers are never invented. If a data source cannot be reached, the report says so plainly and states what could not be checked.

## 7. Security and succession

- Read-only by design. The plugin never changes site content, settings, users, themes, or other plugins, and never installs, updates, or activates anything. Its only writes are to its own data: its WordPress options (the daily and monthly inventory snapshots, its version, and its settings such as the recipient address) and its own WP-Cron events.

- No secrets in code. The plugin ships with no passwords, keys, or tokens.

- Local Docker first, then dev. All development and testing happens on the local Docker site, then dev.shoalsaa.org. Plugin files reach dev only through the automated deploy (`docs/deploy.md`) after CI passes. Nothing is installed on the live site until the webservant has tested it on dev and approved it.

- Code storage. The plugin source is district property. Its canonical home is the District 1 GitHub repository <https://github.com/shoalsaa/shoalsaa-website>.

## 8. Testing plan

Testing proceeds in two stages. Complete and pass Stage 1 before installing
the plugin on `dev.shoalsaa.org`. The live site is not touched unless the
webservant later explicitly approves it.

Branching and merge: every green CI run on `main` deploys the plugin to dev,
and CI does not run Stage 1. Develop on a branch, run Stage 1 from that
branch, and merge to `main` only after Stage 1 passes (see
`docs/deploy.md`, "Branching and merge").

### Stage 1 — local Docker site (basic integration)

Use the local WordPress environment documented in `docker/README.md`.
Configure Post SMTP to deliver only to Mailpit.

1. Install and activate the plugin. Confirm clean activation, no new Site
   Health issues, and no PHP errors in the debug log.
2. Verify daily and last-Sunday monthly schedules are registered, and use
   the admin buttons to trigger both reports.
3. Confirm both messages arrive in Mailpit, include the local site's own
   URL, and contain the expected report sections. Check the monthly email's
   reporting period and the same WPvivid status fields as the daily email.
4. Exercise key status behavior: failed last backup is prominent in the
   daily email; disabled backup schedule is labeled WARNING in both emails.
5. A bare local install does not contain production data. Install local
   copies of Burst and WPvivid when needed for integration checks. Verify
   unavailable-data handling when a plugin, Cloudflare credential, or API
   is absent. Treat local results as workflow and formatting checks, not as
   confirmation of production figures.

### Stage 2 — `dev.shoalsaa.org` (data verification)

Proceed only after Stage 1 passes. Sign in as `districtone`; do not test on
the live site.

1. Merge the branch to `main` (only after Stage 1 passes); the deploy
   workflow copies the plugin to dev once CI passes. Activate it in WP Admin. Confirm clean activation, Site Health,
   and debug log.
2. Compare inventory, updates, Burst statistics, and WPvivid schedule/last/
   next-backup fields against the corresponding WordPress admin screens.
   Verify warning and failed-backup behavior with available test data.
3. Verify App for Cloudflare credentials and permissions, request the
   matching GraphQL analytics period, and compare its totals against
   Cloudflare's dashboard.
4. Trigger both reports and inspect delivery, origin URL, data, warnings,
   and the monthly reporting period. Confirm missing or unreachable data
   is identified rather than guessed.

Only consider live-site installation after all staging checks pass and the
webservant explicitly approves it.

## 9. Risks and unknowns

1. PDF/TCPDF is out of scope. The monthly report uses plain email text, removing the dependency on the 12 Step Meeting PDF Generator plugin and any bundled PDF library.

## Appendix A — Verified facts this design rests on

All checked 15 November 2026 unless dated otherwise. Nothing here is assumed.

- WordPress 7.1.5 (Nov 20 2026), PHP 8.4.27, MySQL 8.4.11, Kadence Child 1.0.0; 14 regular plugins (13 active, 1 inactive) plus must-use Burst REST API Optimizer 1.3.0.

- Cloudflare dashboard widget: Day / Week / Month / Year only, no custom range; Month is a rolling last 30 days (16 October–14 November when checked 15 November 2026: 22.25k visitors, 453.35k requests, 36.57% cached, 4 GB served, 23k threats); the Year button does not refresh the widget, likely because there is not yet a years data).

- Burst widget: Today / Yesterday / Last 7 / 30 / 90 days, no custom range; Last 30 days showed 346 visitors, 897 pageviews. Exact period figures (16 October–15 November 2026: 354 visitors, 902 pageviews, 570 sessions) come only from the Burst statistics page, which allows a custom range.

- WPvivid 0.9.140: Backup Schedule is Enabled; schedule Monthly; last backup 13 November 2026 14:50 (Succeeded); next backup Monday 30 November 2026 00:02. The report reads this status only; it does not verify or restore backup archives.

- Five plugins auto-updated 15 November 2026: Burst 3.7.4 → 3.7.5, EWWW 8.9.1 → 8.9.2, Kadence Blocks 3.9.0 → 3.9.1, MEC 7.38.1 → 7.38.2, Burst REST API Optimizer 1.2.0 → 1.3.0.

## Appendix B — Where things live

- This document: `docs/site-report-plugin-design.md` in <https://github.com/shoalsaa/shoalsaa-website>.

- Test site: <https://dev.shoalsaa.org> (DreamHost-migrated copy of <www.shoalsaa.org>, behind Cloudflare). Deploys: `.github/workflows/deploy.yml`, setup in `docs/deploy.md`.

- Former test site: <https://test.shoalsaa.org>, replaced by dev on 27 November 2026.

- Live site: <https://www.shoalsaa.org>.

- Website succession plan: its own repository (Website-succession-plan), not this one.
