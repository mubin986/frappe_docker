#!/bin/bash

# Load configuration
CONFIG_FILE="$(dirname "$0")/config.json"
if [ -f "$CONFIG_FILE" ]; then
    BACKUP_DB=$(jq -r '.backup_paths.database' "$CONFIG_FILE")
else
    echo "Error: config.json not found. Please run 'cli.py config --backup-database' first."
    exit 1
fi

if [ -z "$BACKUP_DB" ]; then
    echo "Error: Database backup path not configured. Please run 'cli.py config --backup-database' first."
    exit 1
fi

docker cp "$BACKUP_DB" frappe_docker-backend-1:/home/frappe/frappe-bench/sites/frontend/private/backups/

docker exec -it frappe_docker-backend-1 bench --site frontend --force restore /home/frappe/frappe-bench/sites/frontend/private/backups/$(basename "$BACKUP_DB")

