#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 || ! "$1" =~ ^[[:xdigit:]]{7,64}$ ]]; then
    printf 'Usage: %s <git-sha>\n' "$0" >&2
    exit 2
fi

sha="$1"
repository="$(gh repo view --json nameWithOwner --jq '.nameWithOwner' | tr '[:upper:]' '[:lower:]')"
image="ghcr.io/${repository}:${sha}"

docker pull "$image"
kind load docker-image "$image" --name quickbite
kubectl set image deployment/quickbite "quickbite=${image}"
kubectl rollout status deployment/quickbite --timeout=120s