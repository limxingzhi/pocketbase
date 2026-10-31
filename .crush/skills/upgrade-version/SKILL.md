---
name: upgrade-version
description: 'Bump the project version across Dockerfile and deploy.yaml. Triggered by: "bump version", "upgrade version", "release X.Y.Z", "bumped to".'
user-invocable: true
---

# Upgrade Version

Bump the project version across all files. PocketBase releases are published on
`https://ganigeorgiev.com/pocketbase/pocketbase/releases` (GitHub releases stopped
at 0.40.6). The deployment repo (`/root/pocketbase`) stores the release in three places:

1. **`Dockerfile`** — `ARG PB_VERSION=<version>`
2. **`Dockerfile`** — `ARG PB_RELEASE_ID=<release-record-id>`
3. **`.github/workflows/deploy.yaml`** — Docker image tag `ghcr.io/...:<version>`

The record id is required because release files are served from
`/api/files/releases/<record-id>/<filename>`; there is no tag-based download path.

## Workflow

### 1. Figure out the new version

If the user didn't specify a version, run the `latest-version.sh` script:

```bash
./latest-version.sh
```

It queries the release API on `ganigeorgiev.com` and prints two space-separated
values: `<version> <release-record-id>`.

The underlying request is:

```
GET https://ganigeorgiev.com/api/collections/releases/records
    ?perPage=1&skipTotal=1&sort=-semver&fields=id,tag
    &filter=channel.name="default" && channel.repository.name="pocketbase" && channel.repository.project.name="pocketbase"
```

### 2. Update `Dockerfile`

Replace `ARG PB_VERSION=<old>` with `ARG PB_VERSION=<new>` and
`ARG PB_RELEASE_ID=<old>` with the new release record id.

The download line must stay:

```
ADD https://ganigeorgiev.com/api/files/releases/${PB_RELEASE_ID}/pocketbase_${PB_VERSION}_linux_amd64.zip /tmp/pb.zip
```

### 3. Update `.github/workflows/deploy.yaml`

Replace the old version tag with the new one on the Docker tag line.

### 4. Commit

Commit with the standard message format: `bumped to <newversion>`

Use `git commit -am 'bumped to X.Y.Z'` with the proper attribution footer, for example:

```
git commit -am "bumped to 0.41.1" -m "💘 Generated with Crush" -m "Assisted-by: Crush:deepseek-v4-flash"
```

## Validation checklist

- [ ] `ARG PB_VERSION=<new>` matches in Dockerfile
- [ ] `ARG PB_RELEASE_ID=<new id>` matches the latest release record
- [ ] `ADD` points at `https://ganigeorgiev.com/api/files/releases/...`
- [ ] `ghcr.io/${{ github.repository }}:<new>` matches in deploy.yaml
- [ ] Commit message follows `bumped to X.Y.Z` format
- [ ] `git status` is clean after commit
