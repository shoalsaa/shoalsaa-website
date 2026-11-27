
# Build Brief Comparison

Compared these files by content using a unified diff:

- Root: `D:\Github_projects\shoalsaa-website\local-model\build-brief.md`
- Nested: `D:\Github_projects\shoalsaa-website\shoalsaa-website\local-model\build-brief.md`

## Summary

The files are substantially different, not just timestamp or formatting variants. The root brief is a compact, numbered implementation specification. The nested brief is longer and reorganized as a model-specific, token-limited, seven-chunk workflow. They share the same overall goal and several safety constraints, but each includes material the other does not.

## In the root brief, absent from the nested brief

- **Read-first direction and decision:** read the design document fully; Phase 1 only; monthly report is a TCPDF PDF attached to an email. It also says the email destination should be configurable with the webservant address as the default. The sentence contains typos: `atached` and `make the email destination is configurable`.
- **Single consolidated build checklist:** four JSON data abilities plus matching REST routes; the monthly PDF ability; TCPDF bundled in the plugin's own `vendor/`; low-privilege Application Password access; a saved inventory snapshot for change tracking; public-source research for Burst and WPvivid; and verification of the MCP Adapter public flag.
- **WordPress Coding Standards** requirement with a link.
- **More detailed deliverables:** main plugin file, includes, bundled TCPDF, readme, and BUILD-NOTES covering public-source verification and live checks, including an online-test build document.
- **Docker test command** uses a placeholder for the localhost WordPress port rather than specifying a port.

## In the nested brief, absent from the root brief

- **Model selection:** names `code-specialist`, Qwen2.5-Coder 7B, quantization, temperature, and the target computer's hardware.
- **Context-window workflow:** explains the 4,096-token limit and directs the model to work in short chunks rather than sending the whole design document.
- **Pre-researched Burst and WPvivid details:** names relevant tables, functions, options, schedule APIs, and limitations; instructs the model not to re-research and not to assume undocumented data.
- **Step-by-step chunks 0-6:** separate skeleton, inventory, backup status, Burst statistics, change tracking, monthly PDF, and tests. The nested brief supplies more per-chunk implementation detail, including REST route and permission expectations.
- **More detailed shared PDF constraints:** explicitly says to report unavailable data rather than invent numbers and to include the generated site's own URL.
- **Concrete Docker test URL:** specifies `http://localhost:8080` and then testing on test.shoalsaa.org.

## Overall

The nested brief adds implementation context and sequencing, while the root brief retains several explicit requirements (notably WordPress Coding Standards and fuller deliverables). Neither file is a strict superset of the other. If one is to become the source of truth, reconcile those root-only requirements into the nested brief before replacing or disregarding either copy.
