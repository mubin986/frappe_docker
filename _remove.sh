#!/bin/bash

# Load configuration
CONFIG_FILE="$(dirname "$0")/config.json"
if [ -f "$CONFIG_FILE" ]; then
    FRAPPE_PATH=$(jq -r '.frappe_path' "$CONFIG_FILE")
    DOCKER_COMPOSE_FILE=$(jq -r '.docker_compose_file' "$CONFIG_FILE")
else
    FRAPPE_PATH="$(dirname "$0")"
    DOCKER_COMPOSE_FILE="pwd.yml"
fi

docker compose -f "$FRAPPE_PATH/$DOCKER_COMPOSE_FILE" down --volumes --remove-orphans
docker volume prune -f
docker network prune -f

docker volume ls
docker network ls
docker image ls
