# PocketBase Docker Deployment

Thin wrapper that downloads a [PocketBase](https://pocketbase.io/) release binary and publishes it as a multi-arch Docker image to `ghcr.io`. No Go source, no test suite, no tooling beyond Docker.

## Key files

| File | Purpose |
|---|---|
| `Dockerfile` | `ADD` (auto-unpacks) the official zip from ganigeorgiev.com |
| `.github/workflows/deploy.yaml` | CI/CD: multi-arch build + push to ghcr.io on push to `main` |
| `.crush/skills/upgrade-version/SKILL.md` | Crush skill to automate version bumps |

## Version management

Releases are published on `https://ganigeorgiev.com/pocketbase/pocketbase/releases`
(the GitHub releases stopped at 0.40.6). Release files are served from
`/api/files/releases/<record-id>/<filename>`, so the release record id is part of
the version pin.

Version lives in **three places** that must stay in sync:

1. `Dockerfile` — `ARG PB_VERSION=<semver>` (filename in the download URL)
2. `Dockerfile` — `ARG PB_RELEASE_ID=<release-record-id>` (path in the download URL)
3. `deploy.yaml` — Docker tag `ghcr.io/<repo>:<semver>`

Commit pattern: `bumped to X.Y.Z`

To resolve the latest pair, query the release API:

```bash
curl -sfL --get https://ganigeorgiev.com/api/collections/releases/records \
  --data-urlencode 'perPage=1' \
  --data-urlencode 'skipTotal=1' \
  --data-urlencode 'sort=-semver' \
  --data-urlencode 'fields=id,tag' \
  --data-urlencode 'filter=channel.name="default" && channel.repository.name="pocketbase" && channel.repository.project.name="pocketbase"'
```

Or run `.crush/skills/upgrade-version/latest-version.sh`, which prints
`<version> <record-id>`.

## CI/CD

- Trigger: push to `main`
- Tags pushed: `latest`, `%Y.%m.%d` (generated at runtime), and the semver tag
- No PR or staging workflow

## Local build

```bash
docker build -t pocketbase:local .
docker run -p 8080:8080 pocketbase:local
# mount /pb/pb_data for persistence
```

## Gotchas

- Changing only the tag in `deploy.yaml` without updating the Dockerfile args will pull a different binary than the tag suggests
- A mismatched `ARG PB_RELEASE_ID` fails the build or, worse, silently points at a different release record; always bump it with `PB_VERSION`
- The `ADD` is hardcoded to `linux_amd64` even though CI builds `linux/amd64,linux/arm64`, so the arm64 image ships an amd64 binary
- The date tag (`%Y.%m.%d`) is computed fresh each CI run — not committed
- `.crush/` is gitignored except `crush.json` and `skills/`
