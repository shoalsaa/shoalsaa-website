# TODO

## Verify Cloudflare access

- Decided: the monthly report is a plain email, and this build reads zone
  analytics through the App for Cloudflare authentication and GraphQL
  pattern (`cloudflareAuth.token`, with email/API-key fallback).
- Verify the live token permissions and zone ID, then compare GraphQL totals
  for an exact period against the Cloudflare dashboard.

## Confirm report data and behavior

- Verify WPvivid's option values and result fields on `dev.shoalsaa.org`
  before relying on them.
- Confirm that the exact same WPvivid Backup Schedule fields appear in both
  reports. Test failed-last-backup notification and disabled-schedule
  WARNING behavior in the daily and monthly email bodies.
- Confirm the WordPress time zone (Settings → General) is America/Chicago on
  dev and live, as the design now assumes.
- Decide whether WP-Cron's approximate timing is sufficient or whether a
  hosting/server cron is needed for the 08:00 daily and 07:00 last-Sunday
  monthly schedule.
- Resolved 27 November 2026: "read-only" is defined in design §7 (the
  plugin writes only its own options and WP-Cron events), the design doc is
  the spec, and monthly usage covers an exact reporting period.

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
