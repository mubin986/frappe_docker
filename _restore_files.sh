#!/bin/bash

# Load configuration
CONFIG_FILE="$(dirname "$0")/config.json"
if [ -f "$CONFIG_FILE" ]; then
    BACKUP_PUBLIC=$(jq -r '.backup_paths.public_files' "$CONFIG_FILE")
    BACKUP_PRIVATE=$(jq -r '.backup_paths.private_files' "$CONFIG_FILE")
    BACKEND_CONTAINER=$(jq -r '.container_names.backend' "$CONFIG_FILE")
else
    echo "Error: config.json not found. Please run 'cli.py config --backup-public-files' and 'cli.py config --backup-private-files' first."
    exit 1
fi

if [ -z "$BACKUP_PUBLIC" ] || [ -z "$BACKUP_PRIVATE" ]; then
    echo "Error: File backup paths not configured. Please run 'cli.py config --backup-public-files' and 'cli.py config --backup-private-files' first."
    exit 1
fi

docker cp "$BACKUP_PUBLIC" "$BACKEND_CONTAINER":/home/frappe/frappe-bench/sites/frontend/private/backups/
docker cp "$BACKUP_PRIVATE" "$BACKEND_CONTAINER":/home/frappe/frappe-bench/sites/frontend/private/backups/

docker exec -it "$BACKEND_CONTAINER" bash -c \
  "tar -xf sites/frontend/private/backups/$(basename "$BACKUP_PUBLIC") -C sites/frontend/public/files/"

docker exec -it "$BACKEND_CONTAINER" bash -c \
  "tar -xf sites/frontend/private/backups/$(basename "$BACKUP_PRIVATE") -C sites/frontend/private/files/"

docker exec -it "$BACKEND_CONTAINER" bash -c \
  "mv sites/frontend/public/files/frontend/public/files/* sites/frontend/public/files/ && rm -rf sites/frontend/public/files/frontend"

docker exec -it "$BACKEND_CONTAINER" bash -c \
  "mv sites/frontend/private/files/frontend/private/files/* sites/frontend/private/files/ && rm -rf sites/frontend/private/files/frontend"
