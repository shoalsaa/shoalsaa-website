# Claude status

Review log of conflicting or out-of-date instructions in this repository.
Each session adds a dated entry. Line numbers refer to the files as they
were at the commit named in the entry.

---

## Session: 2026-11-27 12:37 CST (UTC−06:00)

Reviewed at commit `945f197` on `main` (clean working tree). All 31 tracked
files were read: Markdown docs, workflows, Docker files, Composer/PHPUnit
config and tests.

Context: the nested `shoalsaa-website/` folder was folded into the top level
and deleted in commit `834a235`. Several documents still give instructions
about it.

### Files with conflicting instructions

| File | Conflicts with | Topics (see sections below) |
| --- | --- | --- |
| [site-report-plugin-design.md](site-report-plugin-design.md) | build-brief.md, deploy.md, README.md, itself | A, C, E, F, G, H, J |
| [../local-model/build-brief.md](../local-model/build-brief.md) | design doc, docker/README.md, ci.yml, composer.json | E, F, G, I |
| [../readme-Docker.md](../readme-Docker.md) | docker/README.md, design doc, itself | A, B, D, K |
| [../docker/README.md](../docker/README.md) | readme-Docker.md, docker-compose.yml, build-brief.md, project-history.md | B, D, I, K |
| [../docker-compose.yml](../docker-compose.yml) | docker/README.md, readme-Docker.md, ci.yml | D, K |
| [../.github/workflows/ci.yml](../.github/workflows/ci.yml) | design doc, build-brief.md, compose comments | C, I, K |
| [../.github/workflows/deploy.yml](../.github/workflows/deploy.yml) / [deploy.md](deploy.md) | design doc §8 (Stage 1 before dev) | H |
| [todo.md](todo.md) | design doc, git history (nested folder gone) | A, B, C, E |
| [project-history.md](project-history.md) | docker/README.md | B, K |
| [build-brief-comparison.md](archive/build-brief-comparison.md) | current build brief, design doc | B, C |
| [duplicates-subfolder.md](archive/duplicates-subfolder.md) | current repo layout | B |
| [../local-model/prompt-chunking.md](../local-model/prompt-chunking.md) | build-brief.md, design doc | B, C |
| [../site-report-plugin/README.md](../site-report-plugin/README.md) | design doc (no phasing) | C, J |
| [README.md](README.md) (docs) | its own location | L |
| [../tests/README.md](../tests/README.md) | ci.yml, design doc | C |
| [../README.md](../README.md) | design doc (who approves live) | J |
| [../composer.json](../composer.json) / [../.gitignore](../.gitignore) | docker/README.md, build-brief.md | I |

#### A. Test-site and backup source: live vs. test vs. dev

- [../readme-Docker.md:191](../readme-Docker.md#L191) says "Use a local test
  copy, not the live site's database", but
  [line 194](../readme-Docker.md#L194) says "Create a migration backup from
  the live site".
- [../docker/README.md:59](../docker/README.md#L59) says to restore a backup
  of **dev**.shoalsaa.org. [todo.md:50](todo.md#L50) and
  [project-history.md](project-history.md) (2026-11-22) say "test-site
  backup", and test.shoalsaa.org was retired on 27 November.
- [../readme-Docker.md:202](../readme-Docker.md#L202) misspells the live URL
  as `www.shoalaa.org`.

#### B. Instructions about the nested folder, which no longer exists

- [../readme-Docker.md:54-62](../readme-Docker.md#L54-L62): "keep the root
  and nested Compose files aligned", "do not run it standalone from the
  nested directory".
- [todo.md:28-42](todo.md#L28-L42): the whole "Reconcile root and nested
  project copies" section, including "Reconcile the root and nested CI
  files" and "Before removing the nested project copy…". It was removed in
  `834a235`.
- [project-history.md](project-history.md) (2026-11-21 and 2026-11-22): the
  "do not run the nested copy" warnings. These are history, but they read as
  if they still apply.
- [build-brief-comparison.md](archive/build-brief-comparison.md) and
  [duplicates-subfolder.md](archive/duplicates-subfolder.md) compare files that no
  longer exist. The comparison describes a brief (Phase 1, TCPDF, REST
  routes, MCP flag) that is no longer the current one.
- [../local-model/prompt-chunking.md](../local-model/prompt-chunking.md) is a
  raw chat transcript. It still says the work is "being done in the
  duplicatly-named subdirectory tree" and ends with an unrelated "Change this
  chat's workspace…" prompt.

#### C. Leftover PDF, REST and phase scope

The design doc ([site-report-plugin-design.md:10](site-report-plugin-design.md#L10),
[line 27](site-report-plugin-design.md#L27)) says there are no phases, no PDF
and no inbound endpoints. These files still say otherwise:

- [../.github/workflows/ci.yml:41-42](../.github/workflows/ci.yml#L41-L42):
  "The endpoint smoke test (REST routes, PDF generation) lands with the
  plugin code".
- [../site-report-plugin/README.md:3](../site-report-plugin/README.md#L3):
  "**Phase 1** of the site-report plugin goes in this directory".
- [../local-model/prompt-chunking.md](../local-model/prompt-chunking.md):
  its proposed layout includes `05-monthly-pdf.md`.
- [build-brief-comparison.md](archive/build-brief-comparison.md): TCPDF, four JSON
  abilities plus REST routes, and Phase 1.
- [todo.md:3](todo.md#L3): the heading "Confirm monthly report format" sits
  over a decision that is already confirmed.
- [site-report-plugin-design.md:63](site-report-plugin-design.md#L63): the
  heading "Email and documents" is left over from the PDF version.

#### D. How the local admin user is created

- [../docker-compose.yml](../docker-compose.yml) and
  [../docker/wordpress-entrypoint.sh](../docker/wordpress-entrypoint.sh)
  install WordPress automatically, with the admin user `districtone` and a
  fixed password.
- [../docker/README.md:29](../docker/README.md#L29) says to "finish the
  WordPress install … choose values for this local install". That install
  screen never appears on a fresh volume.
- [../readme-Docker.md:193](../readme-Docker.md#L193) has you fill in General
  Settings by hand. The entrypoint sets the title "ShoalsAA Local Test", but
  readme-Docker says "shoalsaa docker test".

#### E. Status of the design document and the meaning of "read-only"

- [site-report-plugin-design.md:11](site-report-plugin-design.md#L11):
  "This is a design, **not a build specification**", but
  [../local-model/build-brief.md:9](../local-model/build-brief.md#L9) says
  "It is **the spec**". [todo.md](todo.md) also flags this.
- [site-report-plugin-design.md:71](site-report-plugin-design.md#L71) says
  the plugin "contains no write operations". But
  [line 50](site-report-plugin-design.md#L50) stores an inventory snapshot in
  a WordPress option, §5 registers WP-Cron events, and the build brief
  (chunk 0) records the version on activation. All three are writes.
- [site-report-plugin-design.md:75](site-report-plugin-design.md#L75): the
  bullet is labelled "Test-site first", but its text and §8 both say local
  Docker comes first.

#### F. What the reports cover and which snapshot they compare against

- The design wants the daily email to show changes "since the previous day"
  and the monthly email to show changes "from the prior month". But
  [line 50](site-report-plugin-design.md#L50) and build-brief chunk 1 keep
  only **one** "last inventory" snapshot, and the daily run overwrites it,
  so the monthly diff would only cover one day.
- [site-report-plugin-design.md:19](site-report-plugin-design.md#L19)
  accepts rolling-month widget figures, while
  [line 51](site-report-plugin-design.md#L51) and build-brief chunk 3
  require the exact reporting period.
- [../local-model/build-brief.md:90](../local-model/build-brief.md#L90) says
  only the **monthly** email states the origin URL. The design and chunk 4
  require it on **every** report.
- In the build brief, chunks 4 and 5 both assemble the monthly email.

#### G. Facts and typos inside the design doc

- [site-report-plugin-design.md:10](site-report-plugin-design.md#L10): the
  recipient is misspelled `wevservant@shoalsaa.org`.
- [site-report-plugin-design.md:134](site-report-plugin-design.md#L134): the
  appendix says "All checked 15 November 2026" but lists "WordPress 7.1.5
  (Nov 20 2026)".
- The section numbers go §1 → §3; there is no §2.
- No time zone is given for the 08:00 and 07:00 schedules.
  [../readme-Docker.md:193](../readme-Docker.md#L193) sets Chicago on the
  local site only.

#### H. Automatic deploy vs. the Stage 1 gate

- [site-report-plugin-design.md:81-82](site-report-plugin-design.md#L81-L82)
  says "Complete and pass Stage 1 before installing the plugin on dev".
- [../.github/workflows/deploy.yml](../.github/workflows/deploy.yml) and
  [deploy.md](deploy.md) deploy to dev on **every** green CI run on `main`.
  CI does not run Stage 1, so any merge to `main` sends untested code to dev.
  Nothing documents that rule: work on branches and merge only after Stage 1
  passes.

#### I. Coding-standards checks: required but not wired up

- [../local-model/build-brief.md:153](../local-model/build-brief.md#L153)
  (chunk 6) says to lint all plugin PHP against the WordPress Coding
  Standards. But [../composer.json](../composer.json) does not include
  `wp-coding-standards/wpcs`, and [ci.yml](../.github/workflows/ci.yml) only
  runs `php -l`.
- [../docker/README.md:68](../docker/README.md#L68) tells the reader to
  `composer require` WPCS by hand, which would change composer.json outside
  the documented setup.
- The two documents link to different WPCS pages:
  [build-brief.md:89](../local-model/build-brief.md#L89) and
  [docker/README.md:67](../docker/README.md#L67).
- [../.gitignore](../.gitignore) does not ignore `/vendor/`, so
  `composer install` (in tests/README and docker/README) leaves the
  dependencies where they could be committed.

#### J. Who approves live: a named person vs. the office

- The design doc ([lines 75, 82, 123](site-report-plugin-design.md#L75))
  gives approval to "Rob".
- [../README.md](../README.md), [deploy.md:48, 75](deploy.md#L48) and
  [../site-report-plugin/README.md:5](../site-report-plugin/README.md#L5)
  give it to "the webservant" (the office). The README's succession section
  says the project should follow the office, not a person.

#### K. Start-up commands and Docker environment facts

- How to start the stack is described three ways:
  [compose header](../docker-compose.yml) and
  [readme-Docker.md](../readme-Docker.md) say `build`, then
  `up -d --no-build`; [docker/README.md:26](../docker/README.md#L26),
  build-brief and [ci.yml](../.github/workflows/ci.yml) say plain
  `docker compose up -d`.
- [../docker/README.md](../docker/README.md) says versions are pinned, but
  `axllent/mailpit:latest` and `php:8.4-apache` are floating tags. The design
  and build brief target PHP 8.4.27 exactly.
- [../docker/README.md:38](../docker/README.md#L38) calls the old database
  volume "MariaDB", while
  [project-history.md:75-76](project-history.md#L75-L76) says
  `shoalsaa-website_db_data` runs on `mysql:8.4`.
- [../readme-Docker.md:45](../readme-Docker.md#L45) says "Ubuntu 26.04.1 LTS
  is the host OS", but every procedure in the file is for Windows/PowerShell.
  Ubuntu probably describes the DreamHost server.

#### L. Files whose content is in the wrong place

- [README.md](README.md) (in `docs/`) says "The site-report plugin goes in
  this directory". It is a copy of the plugin folder's README and is wrong
  for `docs/`.
- [shoalsaa-performance-issues-2026-11-26.md](shoalsaa-performance-issues-2026-11-26.md)
  is general Lighthouse/DreamPress advice. The site runs on DreamHost shared
  hosting, not DreamPress, and the README says the repository is for the
  plugin only.

### Recommendations — 2026-11-27

In priority order.

Update 2026-11-27: items 1–5 are done (merged in PRs #4 and #5).
For item 3, dev.shoalsaa.org is the backup source. For item 4,
`composer.lock` is now committed. Item 5 uses separate daily and monthly
snapshots.

Update 2026-11-27: item 6 is done. Rob verified that the dev.shoalsaa.org
admin password differs from the local Docker one in `docker-compose.yml`.

Update 2026-11-27 (later): items 7–13 are done (merged in PR #6, branch
`docs/scope-cleanup`). Decisions made by Rob:

- Item 7: the two comparison docs moved to `docs/archive/` with a note;
  the nested-folder section is gone from todo.md, and the history and
  readme-Docker.md entries are marked superseded.
- Item 9: the design doc is the build specification; the build brief says
  the design wins where they differ. §2 Scope added (no renumbering, so
  references to §8 still work).
- Item 10: "read-only" is defined in design §7; the todo item is closed.
- Item 11: schedules use the site time zone (America/Chicago, to be
  confirmed on dev and live, now a todo item). Monthly usage covers an exact
  period, from the previous monthly run to this run, with rolling windows
  only as a labelled fallback.
- Item 12: approvals belong to "the webservant" in the design doc, build
  brief and plugin README.
- Item 13: the origin URL is on every email; chunk 4 is the daily email and
  shared sending, chunk 5 the monthly email; one WPCS link
  (developer.wordpress.org) in the build brief and docker/README.md; the
  dev-site test document is `docs/dev-site-test.md`.

Update 2026-11-27 (later): item 14 is done on branch `chore/wpcs-check`.
WPCS 3 is a Composer dev dependency (phpcs installer allowed); the
`phpcs.xml.dist` ruleset checks `site-report-plugin/` against the full
WordPress standard with the `shoalsaa-site-report` text domain and
`shoalsaa_site_report` prefix; CI runs `vendor/bin/phpcs` after
`composer install`. `composer lint` / `composer lint:fix` run it locally.
The manual `composer require` line is gone from docker/README.md. Also:
`composer.json` declares the MIT license, and `.gitignore` ignores the
PHPUnit result cache.

Items 15–20 (Docker docs and cleanup) are still open.

**Fix now (they affect correctness or safety)**

1. **Fix the recipient typo**: `wevservant` → `webservant` in
   [site-report-plugin-design.md:10](site-report-plugin-design.md#L10). A
   model following the brief could copy it into the code.
2. **Protect dev from untested merges.** Add a "Branching and merge" rule to
   [deploy.md](deploy.md) and design §8: develop on branches, and merge to
   `main` only after Stage 1 passes. Consider protecting `main` with a
   required pull request.
3. **Choose one backup source for the local restore** (dev is the likely
   choice, since test was retired). Then make
   [../readme-Docker.md](../readme-Docker.md) steps 1 and 4,
   [../docker/README.md](../docker/README.md) and [todo.md](todo.md) agree,
   and fix `shoalaa.org`.
4. **Add `/vendor/` to [../.gitignore](../.gitignore).** Decide whether to
   commit `composer.lock` (recommended, so CI is reproducible).
5. **Fix the snapshot design**: keep separate daily and monthly snapshots,
   or a dated change log, so the monthly "changes from the prior month" is
   correct. Update design §4 and build-brief chunk 1 to match.
6. **Check the `districtone` password.** If dev uses the same username and
   the same password as the one in
   [../docker-compose.yml](../docker-compose.yml), change it on dev. The
   compose value is now public in Git history.

**Bring the documents in line with the current scope**

7. **Rewrite or retire the nested-folder material**: delete the "Reconcile
   root and nested project copies" section from [todo.md](todo.md), cut the
   nested-copy wording from readme-Docker.md, and move
   [build-brief-comparison.md](archive/build-brief-comparison.md) and
   [duplicates-subfolder.md](archive/duplicates-subfolder.md) to a `docs/archive/`
   folder (or delete them; git history keeps them).
8. **Remove the leftover PDF, REST and phase wording**: the ci.yml comment,
   "Phase 1" in the plugin README, the todo heading, and the design §6
   title ("Email" only).
9. **Settle the design doc's status.** Either call it the spec (and drop
   "not a build specification") or change the build brief's "It is the
   spec". Add a §2 or renumber.
10. **Define "read-only" precisely** in design §7: no changes to content,
    settings, users or plugins; the plugin may write only its own options
    (snapshot, version, settings) and its own cron events. Close the
    matching todo item.
11. **Name a time zone for the schedules** in design §1/§5 (America/Chicago,
    following the WordPress site setting). Decide between "exact period"
    and "rolling month" for Cloudflare and Burst, and state the choice once.
12. **Use "the webservant" for approvals** in the design doc instead of a
    named person, to match the README's succession principle.
13. **Fix the build brief**: the origin URL goes on *every* report; merge
    or clearly split chunks 4 and 5; pick one WPCS link; rename
    `Online-Test/Build_Online.md` to something for dev.

**Tidy up the tooling and Docker docs**

14. **Wire up the coding-standards check**: add `wp-coding-standards/wpcs`
    (and `allow-plugins` for the phpcs installer) to
    [../composer.json](../composer.json), add a `phpcs.xml.dist`, add a
    phpcs step to [ci.yml](../.github/workflows/ci.yml), and remove the
    manual `composer require` line from docker/README.md.
15. **Use one start-up command everywhere.** `docker compose up -d --build`
    works for docs and CI alike. Update docker/README.md (no "finish the
    install" step; mention the auto-created `districtone` admin),
    readme-Docker.md, the compose header and build-brief.
16. **Pin Mailpit** to a specific version. Either pin the PHP image to the
    patch version or state that the patch floats.
17. **Split [../readme-Docker.md](../readme-Docker.md)**: move the
    conversation record into [project-history.md](project-history.md) and
    keep a short how-to (start, restore, copy backups, safety). Fix the
    "host OS" sentence and the MariaDB/MySQL volume note.
18. **Replace [README.md](README.md) in `docs/`** with a short index of the
    docs folder (or delete it).
19. **Turn [../local-model/prompt-chunking.md](../local-model/prompt-chunking.md)
    into guidance**: keep the useful advice (prompt budget, human-only
    blocks, a prompt-assembly script) as plain guidance, and drop the
    transcript and the PDF chunk name. Otherwise fold it into the build
    brief.
20. **Move the performance notes** out of this repository, or label them as
    live-site operations notes (outside the plugin's scope) and remove the
    DreamPress-only advice.
