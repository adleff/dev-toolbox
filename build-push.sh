#!/usr/bin/env bash
# Usage: ./build-push.sh <dockerhub-username> [tag]

set -euo pipefail

DOCKER_USER="${1:?usage: $0 <dockerhub-username> [tag]}"
TAG="${2:-latest}"
IMAGE="${DOCKER_USER}/dev-toolbox:${TAG}"

echo "==> Building multi-arch image: ${IMAGE}"

# Ensure buildx builder exists with multi-platform support
docker buildx create --name toolbox-builder --use --bootstrap 2>/dev/null || \
    docker buildx use toolbox-builder

docker buildx build \
    --platform linux/amd64,linux/arm64 \
    --tag "${IMAGE}" \
    --push \
    .

echo "==> Pushed: ${IMAGE}"
echo "    Pull anywhere with: docker pull ${IMAGE}"