

I’ll retrieve the current modification times for each same-relative-path file pair, including nested subfolders.

Ran terminal command: $root=(Get-Location).Path; $nested=Join-Path $root 'shoalsaa-website'; Get-ChildItem -LiteralPath $nested -Recurse -File | ForEach-Object { $rel=$_.FullName.Substring($nested.Length+1); $rootPath=Join-Path $root $rel; if(Test-Path -LiteralPath $rootPath -PathType Leaf){ $rootFile=Get-Item -LiteralPath $rootPath; [pscustomobject]@{RootPath=$rootFile.FullName;RootModified=$rootFile.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss');NestedPath=$_.FullName;NestedModified=$_.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss')} } } | ConvertTo-Csv -NoTypeInformation

Modification times below are shown in local time (24-hour format).

| Top-level file (full path) | Modified | Subfolder file (full path) | Modified |
|---|---|---|---|
| `D:\Github_projects\shoalsaa-website\.gitignore` | 2026-11-16 08:38 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\.gitignore` | 2026-11-17 14:02 |
| `D:\Github_projects\shoalsaa-website\composer.json` | 2026-11-17 11:35 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\composer.json` | 2026-11-17 14:02 |
| `D:\Github_projects\shoalsaa-website\docker-compose.yml` | 2026-11-18 15:22 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\docker-compose.yml` | 2026-11-17 14:02 |
| `D:\Github_projects\shoalsaa-website\LICENSE` | 2026-11-16 08:38 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\LICENSE` | 2026-11-17 14:02 |
| `D:\Github_projects\shoalsaa-website\phpunit.xml.dist` | 2026-11-17 11:35 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\phpunit.xml.dist` | 2026-11-17 14:02 |
| `D:\Github_projects\shoalsaa-website\README.md` | 2026-11-16 08:38 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\README.md` | 2026-11-17 14:02 |
| `D:\Github_projects\shoalsaa-website\.github\workflows\ci.yml` | 2026-11-17 11:35 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\.github\workflows\ci.yml` | 2026-11-17 14:02 |
| `D:\Github_projects\shoalsaa-website\docker\README.md` | 2026-11-18 18:39 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\docker\README.md` | 2026-11-17 14:02 |
| `D:\Github_projects\shoalsaa-website\docs\site-report-plugin-design.md` | 2026-11-19 12:33 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\docs\site-report-plugin-design.md` | 2026-11-17 14:02 |
| `D:\Github_projects\shoalsaa-website\docs\website-succession-plan.md` | 2026-11-17 17:14 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\docs\website-succession-plan.md` | 2026-11-17 14:02 |
| `D:\Github_projects\shoalsaa-website\local-model\build-brief.md` | 2026-11-18 17:54 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\local-model\build-brief.md` | 2026-11-17 14:02 |
| `D:\Github_projects\shoalsaa-website\site-report-plugin\README.md` | 2026-11-17 11:35 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\site-report-plugin\README.md` | 2026-11-17 14:02 |
| `D:\Github_projects\shoalsaa-website\tests\bootstrap.php` | 2026-11-17 11:35 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\tests\bootstrap.php` | 2026-11-17 14:02 |
| `D:\Github_projects\shoalsaa-website\tests\README.md` | 2026-11-17 11:35 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\tests\README.md` | 2026-11-17 14:02 |
| `D:\Github_projects\shoalsaa-website\tests\Unit\SanityTest.php` | 2026-11-17 11:35 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\tests\Unit\SanityTest.php` | 2026-11-17 14:02 |

## Creation timestamps

Creation timestamps are shown in local time and rounded to the nearest second. Windows creation times can reflect when files were copied to this location, not when their contents were first created.

| Top-level file (full path) | Created | Subfolder file (full path) | Created |
|---|---|---|---|
| `D:\Github_projects\shoalsaa-website\.gitignore` | 2026-11-15 14:11:20 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\.gitignore` | 2026-11-15 13:37:32 |
| `D:\Github_projects\shoalsaa-website\composer.json` | 2026-11-17 11:15:04 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\composer.json` | 2026-11-17 11:15:04 |
| `D:\Github_projects\shoalsaa-website\docker-compose.yml` | 2026-11-17 11:15:04 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\docker-compose.yml` | 2026-11-17 11:15:04 |
| `D:\Github_projects\shoalsaa-website\LICENSE` | 2026-11-15 14:11:20 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\LICENSE` | 2026-11-15 13:37:36 |
| `D:\Github_projects\shoalsaa-website\phpunit.xml.dist` | 2026-11-17 11:15:04 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\phpunit.xml.dist` | 2026-11-17 11:15:04 |
| `D:\Github_projects\shoalsaa-website\README.md` | 2026-11-15 14:11:20 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\README.md` | 2026-11-17 11:15:08 |
| `D:\Github_projects\shoalsaa-website\.github\workflows\ci.yml` | 2026-11-17 11:15:04 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\.github\workflows\ci.yml` | 2026-11-17 11:15:04 |
| `D:\Github_projects\shoalsaa-website\docker\README.md` | 2026-11-17 11:15:04 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\docker\README.md` | 2026-11-17 11:15:04 |
| `D:\Github_projects\shoalsaa-website\docs\site-report-plugin-design.md` | 2026-11-15 13:37:28 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\docs\site-report-plugin-design.md` | 2026-11-17 10:58:08 |
| `D:\Github_projects\shoalsaa-website\docs\website-succession-plan.md` | 2026-11-16 16:40:36 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\docs\website-succession-plan.md` | 2026-11-17 10:53:24 |
| `D:\Github_projects\shoalsaa-website\local-model\build-brief.md` | 2026-11-17 11:15:04 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\local-model\build-brief.md` | 2026-11-17 11:32:54 |
| `D:\Github_projects\shoalsaa-website\site-report-plugin\README.md` | 2026-11-17 11:15:04 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\site-report-plugin\README.md` | 2026-11-17 11:15:04 |
| `D:\Github_projects\shoalsaa-website\tests\bootstrap.php` | 2026-11-17 11:15:04 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\tests\bootstrap.php` | 2026-11-17 11:15:04 |
| `D:\Github_projects\shoalsaa-website\tests\README.md` | 2026-11-17 11:15:04 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\tests\README.md` | 2026-11-17 11:15:04 |
| `D:\Github_projects\shoalsaa-website\tests\Unit\SanityTest.php` | 2026-11-17 11:15:04 | `D:\Github_projects\shoalsaa-website\shoalsaa-website\tests\Unit\SanityTest.php` | 2026-11-17 11:15:04 |


