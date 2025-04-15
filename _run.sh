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
    
    # Create a temporary file
    TMP_FILE=$(mktemp)
    
    # Process the file to update the port
    awk -v port="$PORT" '
        /ports:/ { 
            print $0; 
            getline; 
            print "    - \"" port ":8080\""; 
            next 
        } 
        { print $0 }
    ' pwd.yml > "$TMP_FILE"
    
    # Replace the original file
    mv "$TMP_FILE" pwd.yml
    
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
