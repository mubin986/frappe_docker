#!/bin/bash

# Load configuration
CONFIG_FILE="$(dirname "$0")/config.json"
if [ -f "$CONFIG_FILE" ]; then
    BACKEND_CONTAINER=$(jq -r '.container_names.backend' "$CONFIG_FILE")
else
    echo "Error: config.json not found. Please run 'cli.py config' first."
    exit 1
fi

docker exec -it "$BACKEND_CONTAINER" bench --site frontend install-app lms
