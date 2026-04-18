#!/usr/bin/env bash
# Usage: ./run.sh [optional extra docker args]
# Reads SCRIPTS_REPO from env if set.
set -euo pipefail

IMAGE="${TOOLBOX_IMAGE:-adleff/dev-toolbox:latest}"

# Resolve symlinks before passing to Docker — dotfiles repo uses symlinks
# for all config files and Docker bind mounts don't follow symlinks outside
# the mounted directory. realpath resolves to the actual file regardless of
# where the dotfiles repo is installed.
#
# SSH keys are mounted individually rather than as a directory to avoid the
# directory mount bringing in symlinks that Docker can't follow.
SSH_DIR="$(realpath "${HOME}/.ssh")"
SSH_CONFIG="$(realpath "${HOME}/.ssh/config")"
AWS_DIR="$(realpath "${HOME}/.aws")"
AWS_CONFIG="$(realpath "${HOME}/.aws/config")"

docker run -it --rm \
    -v "${SSH_DIR}/id_ed25519_personal:/root/.ssh/id_ed25519_personal:ro" \
    -v "${SSH_DIR}/id_ed25519_personal.pub:/root/.ssh/id_ed25519_personal.pub:ro" \
    -v "${SSH_DIR}/id_ed25519_rpl:/root/.ssh/id_ed25519_rpl:ro" \
    -v "${SSH_DIR}/id_ed25519_rpl.pub:/root/.ssh/id_ed25519_rpl.pub:ro" \
    -v "${SSH_CONFIG}:/root/.ssh/config:ro" \
    -v "${AWS_DIR}:/root/.aws:ro" \
    -v "${AWS_CONFIG}:/root/.aws/config:ro" \
    -e "SCRIPTS_REPO=${SCRIPTS_REPO:-}" \
    -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:-}" \
    -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:-}" \
    -e "AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-us-west-2}" \
    "$@" \
    "${IMAGE}"
