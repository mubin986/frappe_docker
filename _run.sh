#!/bin/bash

# Get port from first argument or use default
PORT=${1:-8080}

echo "Setting port to: $PORT"

# Update pwd.yml with the new port
if [ -f "pwd.yml" ]; then
    echo "Updating pwd.yml..."
    
    # First, clean up any existing port configurations
    sed -i.bak '/ports:/,+2d' pwd.yml
    rm -f pwd.yml.bak
    
    # Add the new port configuration
    sed -i "/frontend:/a \    ports:\n    - \"${PORT}:8080\"" pwd.yml
    
    # Verify the change
    echo "New port configuration:"
    grep -A 2 "ports:" pwd.yml
else
    echo "Error: pwd.yml not found!"
    exit 1
fi

# Run docker compose
echo "Starting containers..."
docker compose -f pwd.yml up -d
