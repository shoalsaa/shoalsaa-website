# Tests

Two layers, matching the design document's testing plan
(`docs/site-report-plugin-design.md`, §8).

## Unit tests — PHPUnit + Brain Monkey

No WordPress install needed. WordPress functions are mocked with
[Brain Monkey](https://brain-wp.github.io/BrainMonkey/), so the plugin's
pure logic (snapshot diffing, report assembly, email content) can be tested
in isolation.

```powershell
composer install
vendor/bin/phpunit
```

Real unit tests land with the plugin code. `tests/Unit/SanityTest.php`
exists only to prove the harness runs.

## Stage 1 — local Docker integration

Boot the local WordPress site (`docker/README.md`), configure Post SMTP to
send only to Mailpit, activate the plugin, and trigger both reports. Verify
scheduling, message delivery and structure, local origin URL, warning
behavior, and graceful handling of unavailable data. Local integration
checks do not validate production figures.

## Stage 2 — staging data verification

After Stage 1 passes, merge to `main` so the deploy workflow copies the
plugin to `dev.shoalsaa.org` (`docs/deploy.md`), then activate it there. Compare inventory,
Burst, WPvivid, and Cloudflare data against their respective admin
screens. Trigger both reports and verify their content and delivery. Do not
install on the live site without Rob's explicit approval.

A scripted smoke test (`tests/smoke.sh`) lands with the plugin code; until
then integration checks are manual.

## CI

`.github/workflows/ci.yml` runs on every push and pull request: PHP lint of
the plugin files, the WordPress Coding Standards check (`composer lint`,
rules in `phpcs.xml.dist`), the unit suite, and a boot check of the Docker
stack.
