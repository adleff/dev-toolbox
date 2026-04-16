#!/usr/bin/env bash
set -euo pipefail

# If a scripts repo URL is provided, clone it into /root/scripts.
# Skip if the directory is already populated (bind-mount case or re-run).
if [[ -n "${SCRIPTS_REPO:-}" && -z "$(ls -A /root/scripts 2>/dev/null)" ]]; then
    echo "[toolbox] Cloning ${SCRIPTS_REPO} into /root/scripts..."
    git clone "${SCRIPTS_REPO}" /root/scripts
    echo "[toolbox] Done."
fi

# Hand off to whatever CMD was passed (default: bash)
exec "$@"