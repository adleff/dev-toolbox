#!/usr/bin/env bash
# Usage: ./run.sh [optional extra docker args]
# Reads SCRIPTS_REPO from env if set.
set -euo pipefail

IMAGE="${TOOLBOX_IMAGE:-yourname/dev-toolbox:latest}"

docker run -it --rm \
    -v "${HOME}/.ssh:/root/.ssh:ro" \
    -v "${HOME}/scripts:/root/scripts" \
    -e "SCRIPTS_REPO=${SCRIPTS_REPO:-}" \
    -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:-}" \
    -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:-}" \
    -e "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-us-east-1}" \
    "$@" \
    "${IMAGE}"