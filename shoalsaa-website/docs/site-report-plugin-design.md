# ShoalsAA Site Report Plugin

Design Document

District 1, Area 1 AA — shoalsaa.org

15 November 2026 — Prepared for Rob, District 1 Web-Committee Chair
20 November 2026 -- revised, eliminate phasing, implement as totally contained in the plugin,no inbound endpoints exposed to the outside world.

Status: first pass, for review. This is a design, not a build specification.

## 1. Purpose

**Daily inventory email.** runs daily at 08:00 and emails a short factual inventory to <webservant@shoalsaa.org> — WordPress / PHP / MySQL / theme / plugin versions, what changed since the previous day, updates pending, and the WPvivid backup schedule status. The same backup status is included in the monthly report. A failed last backup prompts immediate attention; a disabled backup schedule is a warning in both reports. No manual updates and no WPvivid archive or restore verification.

**Monthly status report.** Fires every Sunday at 07:00 and runs only on the last Sunday of the month (first real run: Sunday 29 November 2026). A brief plain-text email to <webservant@shoalsaa.org> contains Cloudflare and Burst usage for the period ending that morning, changes and updates from the prior month, current versions, and the same WPvivid backup schedule status included in the daily report.

- The reports do not need to be exact to the minute or visit. Rolling-month widget figures are acceptable, with the period they cover stated in the report.

- Every report states the origin site's own URL at the top, so the recipient can tell which site sent it — live: <https://www.shoalsaa.org>; test: <https://test.shoalsaa.org> The URL is that of the site the report was generated from, never a hardcoded live-site URL.

- Reports go to <webservant@shoalsaa.org>, the district webservant mailbox, which is meant to move with the office when it changes hands — not to Rob's personal email.

- Changes to site pages are not in the report scope.

- The monthly report is plain email text, like the daily report. No attachment or PDF library is needed.

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
| WPvivid backup status (version, schedule, last/next backup, last result) | WPvivid's stored options — TO BE VERIFIED on the test site <https://test.shoalsaa.org>. | WPvivid 0.9.140. Backup Schedule is Enabled; server time, recurrence, last backup 13 Nov 2026 14:50 (Succeeded), and next backup Monday 30 Nov 2026 00:02 are included in both reports without archive or restore verification. A failed last result is prominent notification in the daily report and remains in the monthly report. A disabled schedule is labeled WARNING in both reports. Confirm the option names during the build. |
| Changes since last report (version moves, plugins added/removed) | Plugin-kept snapshot (a WordPress option) diffed on each run | The plugin stores the last inventory it produced and reports what moved. This replaces the external changes log for version changes. |
| Cloudflare usage | App for Cloudflare stored authentication and Cloudflare GraphQL API | Reuse the same WordPress-hosted credentials and zone/hostname lookup used by App for Cloudflare: bearer token at `cloudflareAuth.token`, or email/API-key fallback. Query `GetZoneAnalytics` with the exact reporting period and include unique visitors, requests, cached requests/bytes, bytes, threats, and period dates. If credentials or the API cannot be reached, report Cloudflare as not checked rather than inventing values. |

## 5. Scheduling

 WP-Cron email from the plugin itself. The plugin should register its own WP-Cron events and email the report with wp_mail (Post SMTP is already installed and handles delivery). Three caveats, all already accepted in principle:

- By default, WordPress checks for due WP-Cron events during site requests, so a report event may run late—often after the next request. More reliable timing requires a server or hosting cron.

- WordPress has no built-in monthly interval. The plugin registers a custom interval and checks for the last Sunday itself.

- Provide buttons on the plugin admin page for triggering each report, will need these during development and testing.

## 6. Email and documents

- Every report states the origin site's own URL at the top — the URL of the site the report was generated from, not always the live site — so the recipient can tell whether it is a test-site report or a live report (decided 15 November 2026).

- Numbers are never invented. If a data source cannot be reached, the report says so plainly and states what could not be checked.

## 7. Security and succession

- Read-only by design. The plugin cannot change the site, and it contains no write operations to be misused.

- No secrets in code. The plugin ships with no passwords, keys, or tokens.

- Test-site first. All development and testing on test.shoalsaa.org. Nothing is installed on the live site until Rob has tested it there himself.

- Code storage. The plugin source is district property. Its canonical home is the District 1 GitHub repository <https://github.com/shoalsaa/shoalsaa-website>.

## 8. Testing plan

Testing proceeds in two stages. Complete and pass Stage 1 before installing
the plugin on `test.shoalsaa.org`. The live site is not touched unless Rob
later explicitly approves it.

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

### Stage 2 — `test.shoalsaa.org` (data verification)

Proceed only after Stage 1 passes. Sign in as `districtone`; do not test on
the live site.

1. Install and activate the plugin. Confirm clean activation, Site Health,
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

Only consider live-site installation after all staging checks pass and Rob
explicitly approves it.

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

- This document: goal workspace.

- Test site: <https://test.shoalsaa.org>.
