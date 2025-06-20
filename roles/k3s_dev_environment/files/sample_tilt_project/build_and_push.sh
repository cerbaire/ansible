#!/bin/bash
set -euxo pipefail 

if [ -z "$EXPECTED_REF" ]; then
  echo "Error: EXPECTED_REF environment variable is not set by Tilt" >&2
  exit 1
fi

CONTEXT_PATH="."
DOCKERFILE_PATH="${CONTEXT_PATH}/Dockerfile"
DOCKERFILE_DIR="${CONTEXT_PATH}"

echo "Building and pushing image: ${EXPECTED_REF}"
echo "Using BUILDKIT_HOST: ${BUILDKIT_HOST}"
echo "Context: ${CONTEXT_PATH}, Dockerfile: ${DOCKERFILE_PATH}"

# Ensure BUILDKIT_HOST is set in the environment this script runs in
# (Tilt should pass it through from its own environment)
buildctl build \
  --frontend dockerfile.v0 \
  --local context="${CONTEXT_PATH}" \
  --local dockerfile="${DOCKERFILE_DIR}" \
  --output type=image,name="${EXPECTED_REF}",push=true

echo "Build and push complete for ${EXPECTED_REF}"