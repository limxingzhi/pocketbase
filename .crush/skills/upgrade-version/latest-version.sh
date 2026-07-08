#!/bin/sh
# Fetches the latest stable PocketBase release version from GitHub.
set -e

# Use GitHub API to get latest release tag, strip the "v" prefix
curl -sfL https://api.github.com/repos/pocketbase/pocketbase/releases/latest |
  sed -n 's/.*"tag_name":\s*"v\([^"]*\)".*/\1/p'
