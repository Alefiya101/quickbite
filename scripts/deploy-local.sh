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
local_image="quickbite:${sha}"
image_container="$(docker create "$image")"
trap 'docker rm -f "$image_container" >/dev/null 2>&1 || true' EXIT
docker export "$image_container" | docker import \
    --change 'WORKDIR /app' \
    --change 'CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]' \
    - "$local_image"
docker rm "$image_container" >/dev/null
trap - EXIT

kind load docker-image "$local_image" --name quickbite
kubectl set image deployment/quickbite "quickbite=${local_image}"
kubectl rollout status deployment/quickbite --timeout=120s