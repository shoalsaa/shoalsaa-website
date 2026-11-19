# MEC Version Monitor Merge Inventory

Compared:

- Source: `D:\Github_projects\mec-version-monitor`
- Destination: `D:\Github_projects\shoalsaa-website`

This inventory treats `D:\Github_projects\shoalsaa-website` as the destination repository root. It has a nested `shoalsaa-website/` folder that appears to be a second scaffold; do not use that nested folder as the destination unless that is intentional.

## Recommendation

The MEC plugin source is not present in the destination tree inspected. The destination's `site-report-plugin/` contains only a placeholder README, and its tests contain only a harness sanity test.

The two plugins have different jobs: MEC checks WordPress.org plugin versions and can email alerts, while the ShoalsAA site-report design calls for a read-only reporting interface. If the version-monitor functionality is still wanted, keep it as a separate plugin—for example, under a new `plugins/mec-version-monitor/` folder—instead of merging it wholesale into `site-report-plugin/`.

The MEC installed-plugin inventory logic may be useful to the site report. Its alerting, admin UI, scheduling, and Ollama summary features do not directly match the site-report design.

## Candidate files to transfer or adapt

| MEC source | Suggested handling |
|---|---|
| `mec-version-monitor.php`, `includes/`, `uninstall.php`, `readme.txt` | Transfer together only if retaining MEC as a separate plugin. These provide its entry point, implementation, cleanup, and WordPress plugin readme. |
| `tests/VersionCompareTest.php` and `tests/ConfigTest.php` | Adapt into the destination's `tests/Unit/` structure. Integrate with its existing test bootstrap rather than replacing it. |
| `docs/ARCHITECTURE.md` | Useful documentation if the version monitor is retained; put it under a distinct docs subfolder. |
| `docs/SETUP.md`, `docs/VERIFICATION.md`, `scripts/` | Use as references and adapt before adopting. They assume MEC-specific commands, ports, and layout. |
| `phpcs.xml.dist` | Potentially useful, but update its file paths and dependencies before use. |
| `.editorconfig` | Optional general editor settings; review before adding. |

## Existing-path conflicts

These paths exist in both repositories. Do not copy over them wholesale; merge or deliberately choose the destination's version.

| Path | Notes |
|---|---|
| `.gitignore` | Different rules. Merge useful MEC exclusions, such as vendor, build output, and environment files, without replacing the destination's rules. |
| `LICENSE` | MEC identifies as GPL-2.0-or-later; ShoalsAA's file says MIT. Resolve component licensing before transferring code; do not replace the destination license. |
| `README.md` | Different project descriptions. Merge only relevant links or notes. |
| `composer.json` | Different dependencies and scripts. The destination already uses PHPUnit and Brain Monkey; integrate only the MEC dependencies and commands that are needed. |
| `docker-compose.yml` | Present in both; the inspected contents appear to match the MEC setup. Do not move another copy. |
| `phpunit.xml.dist` | Configures different test locations. Preserve the destination's `tests/Unit` layout and merge test configuration as needed. |
| `.github/workflows/ci.yml` | Different CI workflows. Merge required checks rather than replacing the destination workflow. |
| `tests/bootstrap.php` | Different setup: MEC loads MEC classes and WordPress stubs; ShoalsAA loads its Composer/Brain Monkey harness. Integrate, do not overwrite. |

### Docker port discrepancy

The inspected `docker-compose.yml` maps WordPress to port **8082**, while destination documentation and CI refer to **8080**. Verify and reconcile this before relying on the Docker setup.

## Paths present in MEC but not at the destination root

Other MEC-only paths include:

- `.gitattributes`
- `.vscode/`
- `composer.lock`
- `LOCAL-PHP-TOOLS-INSTRUCTIONS.txt`
- `UPDATED_VSCODE_TRANSFER.md`
- `includes/`
- `mec-version-monitor.php`
- `phpcs.xml.dist`
- `readme.txt`
- `scripts/`
- `uninstall.php`
- `.github/workflows/docker-verify.yml`

Most are MEC-specific setup or tooling and should not be copied without review. Evaluate the MEC Docker verification workflow for integration into the destination CI rather than copying it over.

## Paths present at the destination but not in MEC

The destination has:

- `local-model/`
- `site-report-plugin/`
- `Shoalsaa Reports Plugin/`
- the nested `shoalsaa-website/` folder

It also has site-report and succession documents under `docs/`, plus destination-specific test and Docker documentation. Keep those as part of the ShoalsAA project.

## Do not transfer

Do not transfer MEC's `.env`, `vendor/`, `.phpunit.cache/`, `dist/`, ZIP archive, or Word document. These are local, generated, or project-specific artifacts—not source to merge.  
