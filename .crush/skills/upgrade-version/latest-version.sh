#!/bin/sh
# Fetches the latest stable PocketBase release from ganigeorgiev.com.
# Prints "<version> <release-record-id>".
set -e

BASE_URL="https://ganigeorgiev.com"

response=$(curl -sfL --get "$BASE_URL/api/collections/releases/records" \
  --data-urlencode "perPage=1" \
  --data-urlencode "skipTotal=1" \
  --data-urlencode "sort=-semver" \
  --data-urlencode "fields=id,tag" \
  --data-urlencode 'filter=channel.name="default" && channel.repository.name="pocketbase" && channel.repository.project.name="pocketbase"')

version=$(printf '%s' "$response" | sed -n 's/.*"tag":"v\?\([^"]*\)".*/\1/p')
release_id=$(printf '%s' "$response" | sed -n 's/.*"id":"\([^"]*\)".*/\1/p')

if [ -z "$version" ] || [ -z "$release_id" ]; then
  echo "failed to parse release metadata: $response" >&2
  exit 1
fi

printf '%s %s\n' "$version" "$release_id"
