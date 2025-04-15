#!/bin/bash

# Get platform from environment variable or use default
PLATFORM=${DOCKER_PLATFORM:-linux/arm64}

docker buildx build \
  --platform $PLATFORM \
  --build-arg=FRAPPE_PATH=https://github.com/frappe/frappe \
  --build-arg=FRAPPE_BRANCH=version-15 \
  --build-arg=PYTHON_VERSION=3.11.9 \
  --build-arg=NODE_VERSION=18.20.2 \
  --build-arg=APPS_JSON_BASE64=$APPS_JSON_BASE64 \
  --tag=frappe-mubin \
  --file=images/custom/Containerfile .
  