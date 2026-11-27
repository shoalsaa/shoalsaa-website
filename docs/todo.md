# TODO

## Confirm monthly report format and behavior

- Confirmed decision: the monthly report is a plain email, like the daily
  report. This removes the PDF/TCPDF dependency and avoids reliance on the
  12 Step Meeting PDF Generator plugin.
- Confirmed Cloudflare decision: this build reads zone analytics through the
  App for Cloudflare authentication and GraphQL pattern. The App for
  Cloudflare options use `cloudflareAuth.token`, with email/API-key fallback.
  Verify the live token permissions and zone ID, then compare GraphQL totals
  against the Cloudflare dashboard.

## Confirm report data and behavior

- Verify WPvivid's option values and result fields on `dev.shoalsaa.org`
  before relying on them.
- Confirm that the exact same WPvivid Backup Schedule fields appear in both
  reports. Test failed-last-backup notification and disabled-schedule
  WARNING behavior in the daily and monthly email bodies.
- Clarify the meaning of “read-only”: the report may need to store an
  inventory snapshot and register WP-Cron events even though it must not
  change site content or settings.
- Decide whether WP-Cron's approximate timing is sufficient or whether a
  hosting/server cron is needed for the 08:00 daily and 07:00 last-Sunday
  monthly schedule.

## Reconcile root and nested project copies

- Resolve the design's remaining contradictions: §7 still says test-site
  first, while §8 now requires local Docker first; the design calls itself
  a first-pass draft while the build brief calls it the spec.
- Resolved Docker Compose parity for merge: the nested Compose file now
  matches the root configuration. The root file is authoritative and is the
  one currently running. Its relative `./docker` and `./site-report-plugin`
  paths assume the repository root, so do not launch the nested copy as a
  standalone stack before consolidation.
- Reconcile the root and nested CI files. Remove obsolete REST/PDF CI
  comments and ensure CI checks the selected Compose configuration.
- Before removing the nested project copy, decide how to promote its unique
  history, TODO, and prompt-chunking notes, and classify root-only merge
  notes and other documents.

## Continue local Docker testing

- Resolved: after removing the port-conflicting application and restarting
  Windows, the root Compose stack is running on port 8080. HTTP returned 200
  with the WordPress installation screen; this is a fresh local setup, not
  yet a restored dev-site backup.
- Obtain a current WPvivid migration backup of `dev.shoalsaa.org` (the single
  backup source for local restores; test.shoalsaa.org was retired on
  27 November 2026) and place the working copy in
  `local-backups/wpvivid/` at the repository root. This directory is
  Git-ignored; do not add, commit, or push any backup archive or its contents.
- Restore the backup only into the local Docker site, then test the restored
  site and serialization-aware URL replacement before relying on it.
- Verify the actual WordPress, PHP, and MySQL versions in the running
  containers. Do not remove any older Docker volumes until their contents
  and backup/recovery needs are understood.
- Configure local Post SMTP to send only to the Mailpit service (`mailpit:1025`)
  and verify test messages appear in Mailpit (`http://localhost:8025`), not in
  an external mailbox.
