# Automated deploy to DreamHost

Recommended 27 November 2026; workflow added in the same change.

`.github/workflows/deploy.yml` copies `site-report-plugin/` to
`wp-content/plugins/shoalsaa-site-report/` on DreamHost with rsync over SSH.
Nothing else in this repository is deployed; WordPress core, the theme, other
plugins, uploads and the database stay managed in WP Admin and backed up by
WPvivid.

- **dev** deploys automatically whenever CI passes on `main`.
- **live** deploys only when started by hand (Actions → Deploy plugin → Run
  workflow → `live`), only from `main`, and only after the required reviewer
  approves it in GitHub.
- The workflow never activates the plugin. Activation stays a manual step in
  WP Admin after the site has been checked.
- Until `site-report-plugin/` contains PHP files, the workflow does nothing.

## What there is to deploy

The test target, <https://dev.shoalsaa.org>, is a WordPress site (WordPress
7.1.5, Kadence theme, Modern Events Calendar, Contact Form 7, TSML,
Post SMTP) served through Cloudflare in front of DreamHost shared hosting
(checked 27 November 2026). The live site, <https://www.shoalsaa.org>, has the
same shape.

This repository is not the website. It holds documents, the local Docker
test stack, CI, and the site-report plugin. There is no build step: the
plugin is plain PHP, and Composer is used only for the dev-time tests. So the
one thing to automate is copying `site-report-plugin/` into the plugins
folder. Before this workflow there was no deploy; anything on the sites was
installed by hand through WP Admin.

## Why rsync over SSH from GitHub Actions

- **Not DreamHost git deploy.** DreamHost shared hosting has no
  push-to-deploy hook from GitHub. A git clone on the server pulled by cron
  would need a GitHub credential stored on DreamHost and would put the whole
  repository (docs, Docker files, tests) under the web root. rsync from
  Actions sends only the plugin folder and keeps the only credential in
  GitHub (and the vault).
- **Not plain SFTP/FTP actions.** They work, but cannot reliably remove
  deleted files and are slower. DreamHost allows SSH for any user switched to
  shell access, and rsync is installed there.
- **Two environments.** dev deploys on every green `main`, so testing on dev
  always matches the repository. live needs a person to start it and approve
  it, which keeps the design doc's rule that nothing reaches the live site
  until the webservant says so.

## One-time setup at DreamHost

1. **Shell user.** In the DreamHost panel (Websites → SFTP Users and Files),
   change the user that owns the site folder from SFTP to SSH. Do this for
   each site's owner if dev and live use different users.
2. **Deploy-only key.** On your own computer:
   `ssh-keygen -t ed25519 -C "github-deploy shoalsaa" -f shoalsaa_deploy`
   (no passphrase). Append `shoalsaa_deploy.pub` to `~/.ssh/authorized_keys`
   for that user on DreamHost. Store the private half in the district vault
   and in GitHub (below) and nowhere else.
3. **Server hostname.** Use the DreamHost server name shown in the panel
   (like `iadN-shared-xx-yy.dreamhost.com`), not the site's domain: the domain
   points at Cloudflare, which does not pass SSH.
4. **Host key.** Connect once from your computer
   (`ssh user@server-hostname`), accept the key, and copy the matching line
   from your `~/.ssh/known_hosts`.
5. **Site path.** Usually `/home/<user>/dev.shoalsaa.org` and
   `/home/<user>/shoalsaa.org` (no trailing slash).

WP-CLI (`wp`) is preinstalled on DreamHost; the workflow uses it only for a
read-only check after copying.

## One-time setup in GitHub

Settings → Environments: create **dev** and **live**. On **live**, add the
webservant as a required reviewer and limit deployment branches to `main`.
Add to each environment:

| Name | Kind | Value |
|---|---|---|
| `DH_SSH_HOST` | Secret | DreamHost server hostname |
| `DH_SSH_USER` | Secret | The shell user |
| `DH_SSH_KEY` | Secret | Private half of the deploy key |
| `DH_KNOWN_HOSTS` | Secret | The known_hosts line from step 4 |
| `DH_SITE_PATH` | Variable | The site path from step 5 |

If dev and live share one user and key, the four secrets can be repository
secrets instead; only `DH_SITE_PATH` then differs per environment.

## Succession

The deploy key is a district secret. List it in the succession plan, keep it
in the vault, and rotate it at every handover: remove its line from
`authorized_keys`, make a new key, and update the `DH_SSH_KEY` secret.
