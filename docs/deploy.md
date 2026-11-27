# Deploying the site-report plugin to DreamHost

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
