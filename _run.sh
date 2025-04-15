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
    
    # Update the port using yq (if available) or sed
    if command -v yq &> /dev/null; then
        yq e ".services.frontend.ports[0] = \"${PORT}:8080\"" -i pwd.yml
    else
        # Use sed with a more specific pattern
        sed -i.bak "s|ports:.*|ports:\n    - \"${PORT}:8080\"|" pwd.yml
        rm -f pwd.yml.bak
    fi
    
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
