#!/bin/bash

# Set the content type
echo "Content-type: text/html"
echo ""

# Read the input from the form
read -r QUERY_STRING

# Extract the target (IP address or hostname) from the query string
TARGET=$(echo "$QUERY_STRING" | sed -n 's/^.*target=\([^&]*\).*$/\1/p')

# Decode URL-encoded characters (e.g., spaces)
TARGET=$(echo -e "${TARGET//%/\\x}")

# Validate that the target is not empty and contains only safe characters
if [[ -z "$TARGET" || ! "$TARGET" =~ ^[a-zA-Z0-9._-]+$ ]]; then
    echo "<h2>Invalid input. Please enter a valid hostname or IP address.</h2>"
    exit 1
fi

# Perform traceroute on the target (IP address or hostname)
TRACEROUTE_RESULT=$(traceroute "$TARGET" 2>&1)

# Display results
echo "<h2>Traceroute Results for $TARGET:</h2>"
echo "<pre>$TRACEROUTE_RESULT</pre>"
