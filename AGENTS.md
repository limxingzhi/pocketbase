# PocketBase Docker Deployment

Thin wrapper that downloads a [PocketBase](https://pocketbase.io/) release binary and publishes it as a multi-arch Docker image to `ghcr.io`. No Go source, no test suite, no tooling beyond Docker.

## Key files

| File | Purpose |
|---|---|
| `Dockerfile` | `ADD` (auto-unpacks) the official zip from GitHub releases |
| `.github/workflows/deploy.yaml` | CI/CD: multi-arch build + push to ghcr.io on push to `main` |
| `.crush/skills/upgrade-version/SKILL.md` | Crush skill to automate version bumps |

## Version management

Version lives in **two places** that must stay in sync:

1. `Dockerfile` — `ARG PB_VERSION=<semver>` (drives the download URL)
2. `deploy.yaml` — Docker tag `ghcr.io/<repo>:<semver>`

Commit pattern: `bumped to X.Y.Z`

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

- Changing only the tag in `deploy.yaml` without updating `ARG PB_VERSION` will pull a different binary than the tag suggests
- The date tag (`%Y.%m.%d`) is computed fresh each CI run — not committed
- `.crush/` is gitignored except `crush.json` and `skills/`
