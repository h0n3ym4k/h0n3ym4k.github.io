#!/bin/bash

# Set the content type
echo "Content-type: text/html"
echo ""

# Read the input from the form
read -r QUERY_STRING

# Extract the text from the query string
TEXT=$(echo "$QUERY_STRING" | sed -n 's/^.*text=\([^&]*\).*$/\1/p')

# Decode URL-encoded characters (e.g., spaces)
TEXT=$(echo -e "${TEXT//%/\\x}")

# Validate that the text is not empty and contains only safe characters
#if [[ -z "$TEXT" || ! "$TEXT" =~ ^[a-zA-Z0-9._-:/]*$ ]]; then
#if [[ -z "$TEXT" || ! "$TEXT" =~ ^[a-zA-Z0-9._-]*$ ]]; then
#if [[ -z "$TEXT" || ! "$TEXT" =~ ^[a-zA-Z0-9._-]+$ ]]; then

#if [[ -z "$TEXT" ]]; then

#    echo "<h2>Invalid input. Please enter valid text or URL.</h2>"
#    exit 1
#fi

# Generate QR code and save it as a PNG file
#QR_FILE="/home/www.98036119lmak.ftp.sh/cgi-bin/qr/qrcode-${TEXT}.png"
#id as not to overwrite too speedy, % how many?web server conn?
id=$((${RANDOM} % 1000))
QR_FILE="/home/www.98036119lmak.ftp.sh/cgi-bin/qr/qrcode-${id}.png"
qrencode -l H -o "$QR_FILE" "$TEXT"

echo "$(date +%c)|qrencode -l H -o \"$QR_FILE\" \"$TEXT\"" >> /tmp/qrcode.log
chmod 640 "$QR_FILE" /tmp/qrcode.log

# Display results
#echo "<h2>Generated QR Code for:</h2>"
#echo "<p>$TEXT</p>"
#echo "<img src=\"./qrcode-${id}.png\" alt=\"QR Code\">"

# Display results with a "Scan Me" frame
echo "<html>"
echo "<head>"
echo "<style>"
echo "body { font-family: Arial, sans-serif; text-align: center; }"
echo ".qr-frame { border: 5px solid #000; padding: 20px; display: inline-block; }"
echo ".scan-text { font-size: 24px; margin-bottom: 15px; }"
echo "</style>"
echo "</head>"
echo "<body>"
echo "<div class='qr-frame'>"
echo "<div class='scan-text'>Scan Me!</div>"
echo "<img src=\"./qrcode-${id}.png\" alt=\"QR Code\">"
echo "</div>"
echo "<h2>Generated QR Code for:</h2>"
echo "<p>$TEXT</p>"
echo "</body>"
echo "</html>"
