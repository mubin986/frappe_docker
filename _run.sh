#!/bin/bash

# Get port from environment variable or first argument or use default
PORT=${PORT:-${1:-8080}}

echo "Setting port to: $PORT"

# Update pwd.yml with the new port
if [ -f "pwd.yml" ]; then
    echo "Updating pwd.yml..."
    
    # Create a temporary file
    TMP_FILE=$(mktemp)
    
    # Process the file to update the port
    awk -v port="$PORT" '
        /frontend:/ { 
            print $0; 
            print "    ports:";
            print "    - \"" port ":8080\"";
            next 
        }
        /ports:/ { next }
        /- "[0-9]*:8080"/ { next }
        { print $0 }
    ' pwd.yml > "$TMP_FILE"
    
    # Replace the original file
    mv "$TMP_FILE" pwd.yml
    
    # Verify the change
    echo "New port configuration:"
    grep -A 2 "ports:" pwd.yml
    
    # Also verify the full frontend service configuration
    echo "Full frontend service configuration:"
    sed -n '/frontend:/,/^  [^ ]/p' pwd.yml
else
    echo "Error: pwd.yml not found!"
    exit 1
fi

# Run docker compose
echo "Starting containers..."
docker compose -f pwd.yml up -d
