# ShoalsAA Site Report Plugin

**Design Document — First Pass**

District 1, Area 1 AA — shoalsaa.org

15 November 2026 — Prepared for Rob, District 1 Web-Committee Chair

Status: first pass, for review. This is a design, not a build specification. Decisions 1 and 4 in §12 were decided 17 November 2026 (Phase 1 only; the monthly report is a PDF built with the TCPDF library already on the site). Decisions 2, 3 and 5 remain open. All development and testing happens on test.shoalsaa.org; nothing goes on the live site until Rob has tested it there.

## 1. Purpose

The District 1 website (shoalsaa.org) already has two reporting jobs that work: a daily site-inventory email and a monthly status report for the District 1 meeting. Today both jobs are done by an external scheduler driving a browser through WP Admin. That works, but it has three weaknesses this plugin is meant to remove:

- **Sign-in fragility. **The jobs can only run when a browser can sign in to WP Admin. The daily run failed four days in a row (11–14 November 2026) at the sign-in step, and only recovered when a fresh sign-in was proven to work on 15 November.

- **An unattended logged-in browser. **The jobs depended on a browser session that was already signed in. Rob does not want to leave his PC logged in to WP Admin, unattended, for days at a time while travelling — and should not have to.

- **Ownership. **The reporting pipeline currently lives in Rob's personal Muse account (his browser, his saved login, his scheduled jobs). The district should own the reporting: the data source, the access key, and the instructions to run it, so a new webservant can take it over without rebuilding it from scratch.

The plugin's job is narrow: gather the report data from inside WordPress and hand it out through a documented, key-authenticated interface. It does not send the emails or keep the schedule — at least not in Phase 1 (§6). It does build the monthly report as a PDF, using the TCPDF library already on the site (see §9). It is read-only by design: it never updates, installs, activates, or changes anything on the site.

## 2. What the reports are today

**Daily inventory email. **Runs daily at about 08:40 America/Chicago. Reads WP Admin (Dashboard > Updates, Plugins, Themes, Site Health > Info) and emails a short factual inventory to webservant@shoalsaa.org — WordPress / PHP / MySQL / theme / plugin versions, what changed since the previous day, and any updates pending. No manual updates, no WPvivid deep-check. The first successful run after the sign-in failures was 15 November 2026, 08:40–09:01, and the first email to the webservant@ address.

**Monthly status report. **Fires every Sunday at 06:00 and runs only on the last Sunday of the month (first real run: Sunday 29 November 2026). A brief PDF document emailed as an attachment to webservant@shoalsaa.org: Cloudflare and Burst usage for the period ending that morning, changes and updates from the prior month, and current versions. A test run on 15 November 2026 worked end to end (as a Word document — the switch to PDF was decided 17 November 2026, see §9).

Decisions already made (15 November 2026) and carried into this design:

- The reports do not need to be exact to the minute or visit. Rolling-month widget figures are acceptable, with the period they cover stated in the report.

- Every report states the origin site's own URL at the top, so the recipient can tell which site sent it — live: https://www.shoalsaa.org; test: https://test.shoalsaa.org. The URL is that of the site the report was generated from, never a hardcoded live-site URL.

- Reports go to webservant@shoalsaa.org, the district webservant mailbox, which is meant to move with the office when it changes hands — not to Rob's personal email.

- Manual changes are on hold; the manual stays as a snapshot synced only with version updates.

- The monthly report is a PDF, not a Word document (decided 17 November 2026). It is built by the plugin with TCPDF, the PDF library already installed with the 12 Step Meeting PDF Generator plugin that produces the printable meeting schedule — see §9.

## 3. Architecture at a glance

Two phases. Phase 1 is the recommended build: it is small, it keeps the email and document pipeline that already works, and it removes the browser and the sign-in from the loop. Phase 2 is optional and only makes sense if the district wants the report fully self-contained inside WordPress.

Phase 1 — plugin as data source (recommended first build):

[Site Report plugin on shoalsaa.org]  →  [MCP Adapter plugin]  →  [Muse MCP connector, key-authenticated]  →  [existing cron jobs: fetch PDF, email]  →  webservant@shoalsaa.org

Phase 2 — optional, plugin as reporter (only if wanted later):

[Site Report plugin on shoalsaa.org]  →  [WP-Cron]  →  [wp_mail via Post SMTP]  →  webservant@shoalsaa.org

In Phase 1 the plugin answers questions and builds the monthly PDF. The scheduled jobs that already exist keep asking the questions and sending the emails — they just ask the plugin instead of driving a browser through WP Admin.

## 4. What the plugin collects

Every item below is data the reports already use today, read from inside WordPress instead of from WP Admin screens. The WordPress source column names the API the plugin will use; where the source is not yet confirmed on the test site, the table says so — the build must verify those rows before relying on them.

| Data the reports need | WordPress source | Notes |
| --- | --- | --- |
| Site identity (site URL) | home_url() / site_url() | Printed at the top of every report, so the recipient can tell which site sent it. Live site: https://www.shoalsaa.org. |
| WordPress version | get_bloginfo('version') | Currently 7.1.4. |
| PHP version | phpversion() | Currently 8.4.27. |
| MySQL / server version | $wpdb->db_version() | Currently 8.4.11. |
| Active theme and version | wp_get_theme() | Kadence Child 1.0.0. |
| All plugins: name, version, active/inactive, auto-update status | get_plugins(), is_plugin_active(), 'auto_update_plugins' option; get_mu_plugins() for must-use | 14 regular plugins (13 active, 1 inactive) plus must-use Burst REST API Optimizer 1.3.0, as of 15 Nov 2026. |
| Updates pending (core, plugins, themes) | wp_get_update_data() / update transients | Counts and available versions; empty when nothing is pending. |
| Burst usage (visitors, pageviews, sessions, top pages, date range) | Burst's own database tables or REST endpoints — TO BE VERIFIED on the test site | Burst 3.7.5. Exact period (e.g. 16 Oct–15 Nov 2026: 354 visitors, 902 pageviews, 570 sessions) comes from the Burst statistics page today; the plugin must find the same data at its source. Do not assume table names — confirm during the build. |
| WPvivid backup status (version, schedule, last/next backup, last result) | WPvivid's stored options — TO BE VERIFIED on the test site | WPvivid 0.9.140. Schedule is Monthly; last backup 13 Nov 2026 14:50 (Succeeded); next 30 Nov 2026 00:02. The backup deep-check is on hold, but version + last/next backup are cheap to expose. Confirm the option names during the build. |
| Changes since last report (version moves, plugins added/removed) | Plugin-kept snapshot (a WordPress option) diffed on each run | The plugin stores the last inventory it produced and reports what moved. This replaces the external changes log for version changes. Content edits are a separate question — see §12. |
| Cloudflare usage | NOT available to the plugin without a Cloudflare API token — see §8 | The one gap. The plugin cannot invent these numbers. |

## 5. How the plugin exposes data

**Primary interface — WordPress Abilities, exposed over MCP. **WordPress 6.9 added the Abilities API to core: a plugin registers named abilities (one action each, with a description, input/output schema, and a permission check). The official MCP Adapter plugin (WordPress.org, version 0.7.1, already installed and active on test.shoalsaa.org) turns registered abilities into MCP tools at the endpoint https://test.shoalsaa.org/wp-json/mcp/mcp-adapter-default-server (live site: https://www.shoalsaa.org/wp-json/mcp/mcp-adapter-default-server).

The exposure rule matters and works in our favour: abilities are private by default. Only abilities that explicitly set their public flag (meta.public / meta.mcp.public) become MCP tools; anything unflagged or malformed fails closed and is not exposed. The plugin will register exactly the abilities the reports need, each flagged public, and nothing else. Suggested abilities:

- shoalsaa-report/get-inventory — versions, theme, plugins, updates pending, site URL.

- shoalsaa-report/get-burst-stats — Burst usage for a requested date range.

- shoalsaa-report/get-backup-status — WPvivid version, schedule, last/next backup, last result.

- shoalsaa-report/get-changes-since — what moved since the last snapshot.

- shoalsaa-report/get-monthly-report-pdf — builds the monthly report as a PDF with TCPDF and returns it for the scheduled job to email (decided 17 November 2026, see §9). One ability is different: this one returns a PDF file, not JSON.

**Secondary interface — a plain REST namespace. **The same handlers will also be reachable at a custom REST route (for example /wp-json/shoalsaa-report/v1/inventory), authenticated the same way. This exists so the data can be checked directly with curl during testing, without needing a full MCP client — and as a fallback if the MCP Adapter changes. The data routes return the same JSON the abilities return; the PDF route returns the PDF file.

**Read-only, by construction. **The plugin registers no write abilities and no write REST routes. There is no tool that can update, install, activate, deactivate, delete, or change anything. Generating a PDF changes nothing stored on the site. If a future need arises for a write operation, it is a separate design decision, not something this plugin grows by accident.

## 6. Scheduling

**Phase 1 — keep the existing external schedule. **The daily (08:40) and monthly (last Sunday, 06:00) cron jobs keep their times and their job definitions. Each run calls the plugin's abilities through the MCP connector instead of opening a browser. No WP-Cron is needed, no browser is opened, no interactive sign-in happens, and no session is left logged in anywhere. This is the smallest change that fixes the actual problem.

**Phase 2 — optional, WP-Cron email from the plugin itself. **If the district later wants the report fully self-contained, the plugin can register its own WP-Cron events and email the report with wp_mail (Post SMTP is already installed and handles delivery). Three caveats, all already accepted in principle:

- WP-Cron fires only when the site gets a visit, so a 06:00 run happens on the first visit after 06:00. Approximate timing is acceptable (decided 15 November 2026).

- WordPress has no built-in monthly interval. The plugin registers a custom interval and checks for the last Sunday itself, the same way the external job does today.

- A Word document in PHP needs a library (PHPWord), or the monthly report becomes an HTML email instead. That is a decision (§12), not a blocker. — SUPERSEDED 17 November 2026: the monthly report is a PDF built with TCPDF, the library already installed with the 12 Step Meeting PDF Generator plugin (see §9). No new document library is needed.

Recommendation: build Phase 1 first. Add Phase 2 only if the district wants the report to survive without any Muse account at all.

## 7. The MCP connector's role

The MCP connector is the transport, not the report. Its job is to carry a question from the scheduled job to the plugin and bring the answer back, authenticated with the district's key. Concretely:

- The MCP Adapter plugin (on the site) exposes the report plugin's abilities as MCP tools at /wp-json/mcp/mcp-adapter-default-server.

- Muse connects to that endpoint as an MCP client (the custom-connector MCP route), authenticating with a WordPress Application Password.

- The scheduled jobs call the tools, fetch the monthly PDF the plugin builds, and email it from the connected Gmail account to webservant@shoalsaa.org.

**The key. **A WordPress Application Password is built into core (since 5.6): a 24-character credential, tied to one user and one app name, that works for the REST API and MCP only — it cannot log in to wp-admin. It is shown once when created, stored hashed, and can be revoked on its own without touching any other credential. The district's key would be named for its purpose (for example, “District reporting”), created on the reporting account, and kept in the district password vault alongside the other site credentials (see the Website Succession Plan, November 2026). It is never written in a document, a chat message, or the plugin code.

**What lives where — and what that means for succession. **The plugin, its abilities, and the MCP Adapter live on the site: district property. The application password lives in the district vault: district property. The MCP connection and the two scheduled jobs live in the webservant's Muse account: personal, and re-created on handover. That is the honest limit of this design: MCP does not create an organization-owned Muse account, and there is no District 1 Muse account. What it does is make the access district-owned and the jobs re-creatable — a new webservant revokes the old key, creates a new one, stores it in the vault, reconnects their own Muse to the same endpoint, and re-creates the two jobs from the job definitions kept in the goal workspace (the .md files under the manual goal's crons/ directory are the source of truth for those definitions). The handover procedure belongs in the manual at the next sync, next to the password-manager decision.

**One security note. **Application passwords carry the full capabilities of their user — WordPress offers no per-key scopes. A key on the districtone (administrator) account would have administrator API rights. Two mitigations, in order of preference: (a) a dedicated low-privilege reporting user (for example, Subscriber) whose app password the plugin's own permission callbacks accept, because the plugin gathers the data server-side and the ability only returns it — to be verified during the build, since reading plugin and update data normally needs administrator capabilities; (b) if that does not work, a districtone key, with the risk documented and mitigated by vault custody, a named key, and revocation on every handover.

## 8. Cloudflare — the one gap

The plugin cannot report Cloudflare usage on its own. Cloudflare analytics live on Cloudflare's side, and the only exact-period source is the Cloudflare API, which needs an API token. The dashboard widget on the WP Admin home page shows rolling figures only (Day / Week / Month / Year buttons, no custom range; Month is a rolling last 30 days — 16 October to 14 November when checked 15 November 2026 — and the Year button does not refresh the widget at all). Three options:

1. **Use the Cloudflare API token, if one exists. **If the “App for Cloudflare” plugin already holds an API token, the report plugin can call the same Cloudflare Analytics API the widget uses, for the exact period. This needs the token to exist, to be readable by the plugin, and to be recorded in the vault. To be verified: whether the plugin stores a usable token.

1. **Keep the widget figures. **The scheduled job reads the dashboard widget's Month figures (rolling 30 days) and states the exact dates they cover — the approach already decided on 15 November 2026, when Rob accepted that the report need not be exact to the minute or visit. No token needed; the only cost is that the figures are rolling, not exact-period.

1. **Accept the gap. **Report Burst only, and state plainly that Cloudflare figures were not obtained. Not recommended while option 2 costs nothing.

Recommendation: option 2 now (it is already decided and it works); investigate option 1 during the build, and switch only if a usable token is found.

## 9. Email and documents (Phase 1)

Changed in one respect, deliberately. The monthly report is now a PDF, built by the plugin with TCPDF (see below), instead of a Word document built by the scheduled job with python-docx. Everything else is unchanged from today: the scheduled jobs send both reports from the connected Gmail account to webservant@shoalsaa.org. The plugin changes how the data is gathered and how the monthly document is built, not how the report is delivered. Two standing rules carry over:

- Every report states the origin site's own URL at the top — the URL of the site the report was generated from, not always the live site — so the recipient can tell whether it is a test-site report or a live report (decided 15 November 2026).

- Numbers are never invented. If a data source cannot be reached, the report says so plainly and states what could not be checked.

**The PDF library. **TCPDF (tecnickcom/tcpdf) is already installed on the site, bundled with the 12 Step Meeting PDF Generator plugin (1.0.4), which produces the printable meeting schedule — confirmed from that plugin's public source, 17 November 2026. The report plugin will use the same library. Whether it bundles its own copy of TCPDF or uses the installed copy is to be verified during the build: depending on another plugin's bundled copy is fragile across updates. No new PDF library needs to be bought or learned.

## 10. Security and succession

- Read-only by design (§5). The plugin cannot change the site, and it contains no write operations to be misused.

- No secrets in code. The plugin ships with no passwords, keys, or tokens. The only credential in the whole design is the application password, held in the district vault — never in the plugin, never in a document, never in chat.

- Named, revocable key. One key, one purpose, one name. Revoked on every handover and whenever there is doubt about it. A revoked test key (“Muse reporting (test)”, 15 November 2026) was already exercised end to end on the test site, including the revoke step.

- Test-site first. All development and testing on test.shoalsaa.org. Nothing is installed on the live site until Rob has tested it there himself.

- Version pinning. The MCP Adapter is pre-1.0 (0.7.1); pin its version and record both plugins' versions in the manual at the next sync, the same way other plugin versions are recorded.

- Code storage. The plugin source is district property. Its canonical home is the District 1 GitHub repository https://github.com/shoalsaa/shoalsaa-website (decided 15 November 2026 — see §12, decision 6; organization and repository created 15 November 2026). The working copy lives with the manual goal's files, and the manual records the repository address.

- Succession link. This design implements the succession plan's principle (November 2026): the district owns the access, the vault holds the top-level secrets, and a new webservant can take over from the documentation alone. The handover steps for this plugin — revoke key, create key, reconnect, re-create the two jobs — belong in the manual.

## 11. Testing plan (test site only)

All steps on test.shoalsaa.org, signed in as districtone. The live site is not touched until every step passes and Rob says so.

1. Install the plugin on the test site. It activates cleanly; Site Health shows no new issues; the debug log shows no errors.

1. Confirm the data sources. For Burst and WPvivid, confirm the tables or options the plugin reads, and compare the plugin's output against the Burst statistics page and the WPvivid page on the test site, figure for figure.

1. List the tools. With a test application password, call the MCP endpoint with a real MCP client (or curl a JSON-RPC tools/list request) and confirm the reporting abilities are listed. The browser cannot do this step — it cannot send an Authorization header — so use a client or curl from the terminal.

1. Check each ability's output against WP Admin. Versions, plugin list, updates pending, Burst figures, backup status — every number checked against the screen it came from.

1. Run the pipeline end to end. A scheduled-job run that calls the plugin through MCP (no browser) produces the daily inventory email to webservant@shoalsaa.org, with the site URL at the top.

1. Generate the monthly PDF. Call the PDF ability and check the file opens, states the origin site's URL at the top, and that every figure in it matches the screen it came from.

1. Revoke and re-test. Revoke the test application password and confirm the endpoint then refuses it (401). Create the real district key only after this passes.

1. Only then consider the live site — install the plugin there, create the district key, store it in the vault, switch the two jobs to the MCP route, and watch the next daily run.

## 12. Open decisions (for Rob)

1. Phase 1 only, or Phase 1 + Phase 2? — DECIDED 17 November 2026: Phase 1 only. Build the plugin as a data source (plus the monthly PDF), and revisit Phase 2 only if the district wants the report to survive without any Muse account at all.

1. Reporting account: a dedicated low-privilege reporting user, or a key on the districtone administrator account? (Depends on what the build verifies in §7.)

1. Cloudflare: investigate the API-token route during the build, or stay with the widget's rolling-month figures as already decided?

1. Monthly document — DECIDED 17 November 2026: PDF, built by the plugin with TCPDF, the library already installed with the 12 Step Meeting PDF Generator plugin (see §9). Applies to Phase 1; if Phase 2 is ever built, the same PDF.

1. Content-edit tracking: should the plugin also log post/page edits (title, type, date) so the monthly “changes” section can include them, or stay with version changes only?

1. Where does the plugin source live canonically — DECIDED 15 November 2026: a GitHub repository under a District 1 organization. Organization https://github.com/shoalsaa and repository https://github.com/shoalsaa/shoalsaa-website created 15 November 2026; first commit pushed 16 November 2026.

## 13. Risks and unknowns

- The MCP Adapter is pre-1.0 (0.7.1). Its interface may change; pin the version and expect to revisit it.

- The Abilities API is new (WordPress 6.9+). It is core now, but long-term stability is unproven; the plain REST namespace (§5) is the hedge.

- Burst's and WPvivid's internal storage is unverified. The build must confirm how each stores its data on the test site; if either turns out to be unreadable from a plugin, that data stays on the browser route and the design says so.

- Application passwords have no scopes. An administrator key is powerful; custody and revocation (§7, §10) are the mitigation, not the technology.

- WP-Cron timing is visit-driven (Phase 2 only). A 06:00 run happens on the first visit after 06:00.

- Cloudflare exact-period figures need a token that may not exist (§8).

- The monthly PDF depends on TCPDF. If the report plugin reuses the copy bundled with the 12 Step Meeting PDF Generator plugin, that plugin's updates can move or replace it; bundling the report plugin's own copy avoids that. To be decided during the build (§9).

- The MCP Adapter on the test site exposes, as far as could be verified on 15 November 2026, most likely no tools by default — abilities are private unless flagged public, and nothing on the site is flagged. The reporting plugin is what creates the tools; the adapter alone creates none.

## Appendix A — Verified facts this design rests on

All checked 15 November 2026 unless dated otherwise. Nothing here is assumed.

- WordPress 7.1.4, PHP 8.4.27, MySQL 8.4.11, Kadence Child 1.0.0; 14 regular plugins (13 active, 1 inactive) plus must-use Burst REST API Optimizer 1.3.0.

- Saved districtone login verified working by fresh cloud-browser sign-ins on both the live site and test.shoalsaa.org (15 November 2026, first attempt, no errors). The 14 November live-site rejection was a one-off; its cause is unknown.

- Daily inventory run 15 November 2026, 08:40–09:01, succeeded and emailed webservant@shoalsaa.org — the first successful run since 10 November.

- MCP Adapter 0.7.1 installed and activated on test.shoalsaa.org (15 November 2026); endpoint https://test.shoalsaa.org/wp-json/mcp/mcp-adapter-default-server confirmed, 401 without authentication; the plugin adds no admin/settings page.

- Abilities are private by default; only flagged-public abilities become MCP tools. The full runtime abilities list could not be retrieved from a browser (401 — no Authorization header); the default server most likely exposes no tools.

- Test application password “Muse reporting (test)” created and revoked on the test site 15 November 2026; never used; revocation verified (Profile page shows no password list). The revoke button's JavaScript confirmation dialog cannot be completed by browser automation — a person must click Revoke and then OK.

- Cloudflare dashboard widget: Day / Week / Month / Year only, no custom range; Month is a rolling last 30 days (16 October–14 November when checked 15 November 2026: 22.25k visitors, 453.35k requests, 36.57% cached, 4 GB served, 23k threats); the Year button does not refresh the widget.

- Burst widget: Today / Yesterday / Last 7 / 30 / 90 days, no custom range; Last 30 days showed 346 visitors, 897 pageviews. Exact period figures (16 October–15 November 2026: 354 visitors, 902 pageviews, 570 sessions) come only from the Burst statistics page, which allows a custom range.

- WPvivid 0.9.140: schedule Monthly and Enabled; last backup 13 November 2026 14:50 (Succeeded); next backup 30 November 2026 00:02; three backups held in Dropbox; no failed entries. The backup deep-check is on hold.

- Five plugins auto-updated 15 November 2026: Burst 3.7.4 → 3.7.5, EWWW 8.9.1 → 8.9.2, Kadence Blocks 3.9.0 → 3.9.1, MEC 7.38.1 → 7.38.2, Burst REST API Optimizer 1.2.0 → 1.3.0.

- 12 Step Meeting PDF Generator 1.0.4 is installed and active; it bundles TCPDF (tecnickcom/tcpdf), confirmed from the plugin's public source 17 November 2026. The monthly report will be a PDF built with TCPDF — no new PDF library is needed.

## Appendix B — Where things live

- This document: goal workspace, files/site-report-plugin-design/site-report-plugin-design.docx (goal: ShoalsAA Website Manual).

- Daily job: daily-site-inventory-email, daily 08:40 America/Chicago, owner goal:shoalsaa-website-manual.

- Monthly job: monthly-site-status-report, Sundays 06:00, runs only on the last Sunday; first real run Sunday 29 November 2026.

- Changes history: ~/workspace/goals/shoalsaa-website-manual/hidden_files/site-changes-log.md plus daily-inventory-YYYY-MM-DD.md logs in the same directory.

- Test site: https://test.shoalsaa.org (MCP Adapter 0.7.1 installed there, 15 November 2026).

- Live site: https://www.shoalsaa.org. MCP Adapter is NOT installed on the live site.

- Succession plan: Website Succession Plan, November 2026 (goal files, website-succession-plan/website-succession-plan.docx) — key custody and handover principles this design follows.
