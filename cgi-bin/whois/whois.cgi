#!/bin/bash

# Set the content type
echo "Content-type: text/html"
echo ""

# Read the input from the form
read -r QUERY_STRING

# Extract the target (domain name or IP address) from the query string
TARGET=$(echo "$QUERY_STRING" | sed -n 's/^.*target=\([^&]*\).*$/\1/p')

# Decode URL-encoded characters (e.g., spaces)
TARGET=$(echo -e "${TARGET//%/\\x}")

# Validate that the target is not empty and contains only safe characters
if [[ -z "$TARGET" || ! "$TARGET" =~ ^[a-zA-Z0-9._-]+$ ]]; then
    echo "<h2>Invalid input. Please enter a valid domain name or IP address.</h2>"
    exit 1
fi

# Perform WHOIS lookup on the target (domain name or IP address)
WHOIS_RESULT=$(whois "$TARGET" 2>&1)

# Display results
echo "<h2>WHOIS Results for $TARGET:</h2>"
echo "<pre>$WHOIS_RESULT</pre>"