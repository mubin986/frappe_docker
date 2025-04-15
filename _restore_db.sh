#!/bin/bash

# Load configuration
CONFIG_FILE="$(dirname "$0")/config.json"
if [ -f "$CONFIG_FILE" ]; then
    BACKUP_DB=$(jq -r '.backup_paths.database' "$CONFIG_FILE")
    BACKEND_CONTAINER=$(jq -r '.container_names.backend' "$CONFIG_FILE")
else
    echo "Error: config.json not found. Please run 'cli.py config --backup-database' first."
    exit 1
fi

if [ -z "$BACKUP_DB" ]; then
    echo "Error: Database backup path not configured. Please run 'cli.py config --backup-database' first."
    exit 1
fi

if [ -z "$BACKEND_CONTAINER" ]; then
    echo "Error: Backend container name not configured. Please run 'cli.py config' first."
    exit 1
fi

echo "Restoring database from $BACKUP_DB to container $BACKEND_CONTAINER..."

docker cp "$BACKUP_DB" "$BACKEND_CONTAINER":/home/frappe/frappe-bench/sites/frontend/private/backups/

docker exec -it "$BACKEND_CONTAINER" bench --site frontend --force restore /home/frappe/frappe-bench/sites/frontend/private/backups/$(basename "$BACKUP_DB")

