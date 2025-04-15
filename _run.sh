#!/bin/bash

# Get port from first argument or use default
PORT=${1:-8080}

# Update pwd.yml with the new port
if [ -f "pwd.yml" ]; then
    # Use sed to replace the port in pwd.yml
    sed -i.bak "s|\"[0-9]*:8080\"|\"${PORT}:8080\"|g" pwd.yml
    rm -f pwd.yml.bak
fi

# Run docker compose
docker compose -f pwd.yml up -d
