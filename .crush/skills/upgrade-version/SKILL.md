---
name: upgrade-version
description: 'Bump the project version across Dockerfile and deploy.yaml. Triggered by: "bump version", "upgrade version", "release X.Y.Z", "bumped to".'
user-invocable: true
---

# Upgrade Version

Bump the project version across all files. The PocketBase deployment repo (`/root/pocketbase`) stores the version in exactly two places:

1. **`Dockerfile`** — `ARG PB_VERSION=<current>`
2. **`.github/workflows/deploy.yaml`** — Docker image tag `ghcr.io/...:<current>`

## Workflow

### 1. Figure out the new version

If the user didn't specify a version, search for the latest stable version on pocketbase's github release page and upgrade to that by default

1. release page - https://github.com/pocketbase/pocketbase/releases

### 2. Update `Dockerfile`

Replace `ARG PB_VERSION=<old>` with `ARG PB_VERSION=<new>`.

### 3. Update `.github/workflows/deploy.yaml`

Replace the old version tag with the new one on the Docker tag line.

### 4. Commit

Commit with the standard message format: `bumped to <newversion>`

Use `git commit -am 'bumped to X.Y.Z'` with the proper attribution footer, for example:

```
git commit -am "bumped to 0.38.3" -m "💘 Generated with Crush" -m "Assisted-by: Crush:deepseek-v4-flash"
```

## Validation checklist

- [ ] `ARG PB_VERSION=<new>` matches in Dockerfile
- [ ] `ghcr.io/${{ github.repository }}:<new>` matches in deploy.yaml
- [ ] Commit message follows `bumped to X.Y.Z` format
- [ ] `git status` is clean after commit
