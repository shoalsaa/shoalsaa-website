# Tests

Two layers, matching the design document's testing plan
(`docs/site-report-plugin-design.md`, §11).

## Unit tests — PHPUnit + Brain Monkey

No WordPress install needed. WordPress functions are mocked with
[Brain Monkey](https://brain-wp.github.io/BrainMonkey/), so the plugin's
pure logic (snapshot diffing, report assembly, PDF content) can be tested
in isolation.

```powershell
composer install
vendor/bin/phpunit
```

Real unit tests land with the plugin code. `tests/Unit/SanityTest.php`
exists only to prove the harness runs.

## Integration tests — the Docker stack

Boot the local WordPress test site (`docker/README.md`), activate the
plugin, and check each REST route against the WP Admin screens, figure for
figure. A scripted smoke test (`tests/smoke.sh`) lands with the plugin
code; until then the checks are manual, per §11 of the design document.

## CI

`.github/workflows/ci.yml` runs on every push and pull request: PHP lint of
the plugin files, the unit suite, and a boot check of the Docker stack.
