#!/bin/bash

# Get port from first argument or use default
PORT=${1:-8080}

echo "Setting port to: $PORT"

# Update pwd.yml with the new port
if [ -f "pwd.yml" ]; then
    echo "Updating pwd.yml..."
    # First check current port
    echo "Current port configuration:"
    grep -A 2 "ports:" pwd.yml
    
    # Update the port
    sed -i.bak "s|\"[0-9]*:8080\"|\"${PORT}:8080\"|g" pwd.yml
    rm -f pwd.yml.bak
    
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
