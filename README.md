# Diksha Ingole · DevOps Portfolio

Personal portfolio site, live at **https://dikshaingole.github.io**

## How it ships

Every push to `main` runs a GitHub Actions pipeline (`.github/workflows/deploy.yml`):

1. **Lint:** HTMLHint checks `index.html`; a failing check blocks the release.
2. **Deploy:** the page is packaged and published to GitHub Pages using OIDC-based deployment, with no stored secrets.

Concurrency control makes sure only the latest push gets deployed.

## Update the site

Edit `index.html`, commit, and push to `main`. The site updates within a minute or two.
