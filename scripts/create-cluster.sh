#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(dirname -- "$script_dir")"
cluster_name="quickbite"

if kind get clusters | grep -Fxq "$cluster_name"; then
    printf 'kind cluster %s already exists\n' "$cluster_name"
    exit 0
fi

kind create cluster \
    --name "$cluster_name" \
    --config "$repo_dir/k8s/kind-config.yaml"