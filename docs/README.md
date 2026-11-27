# Docs

Documents for the ShoalsAA site-report plugin project. The plugin source
goes in `site-report-plugin/`, not here.

| File | What it is |
| --- | --- |
| `site-report-plugin-design.md` | The design and build specification. Start here. |
| `todo.md` | Open work. |
| `project-history.md` | What has been done and decided, by date, plus the local Docker setup record. |
| `deploy.md` | Automated deploy of the plugin to DreamHost (dev and live), one-time setup, and the branching and merge rule. |
| `claude-status.md` | Review log of conflicting instructions found in the repository, with recommendations and their status. |
| `shoalsaa-performance-issues-2026-11-26.md` | Live-site operations notes on a Lighthouse audit finding; outside the plugin's scope. |
| `archive/` | Historical notes kept for reference; not current instructions. |

Elsewhere in the repository:

- `local-model/build-brief.md` and `local-model/prompt-chunking.md` — building
  the plugin with a local model.
- `docker/README.md` — Stage 1 plugin testing on the local Docker site;
  `readme-Docker.md` — running, managing and restoring that site.
- `tests/README.md` — unit tests, the two test stages, and CI.
