#!/bin/bash

# Output HTTP headers
echo "Content-Type: text/html"
echo ""

# Read input from form data
read -r -d '' POST_DATA

# Extract the text from the POST data and decode URL-encoded characters
text=$(echo "$POST_DATA" | sed 's/.*text=//; s/%0A/\n/g; s/%0D//g; s/%3A/:/g; s/%3B/;/g; s/%2C/,/g')

# Extract the text from the POST data
#text=$(echo "$POST_DATA" | sed 's/.*text=//; s/%0A/\n/g; s/%0D//g')
#text=$(echo "$POST_DATA")
#text="$(cat)"
echo "$POST_DATA" > /tmp/data.chk
echo "$text" > /tmp/data.chk.2

#id as not to overwrite too speedy, % how many?web server conn?
id=$((${RANDOM} % 1000))
QR_FILE="/home/www.98036119lmak.ftp.sh/cgi-bin/qr2/qrcode-${id}.png"

# Generate the QR code
#qrencode -o /tmp/output.png -l H -s 200 "$text"
#qrencode -o /tmp/output.png -l H -s 3 "$text"
#cp /tmp/output.png /home/www.98036119lmak.ftp.sh/cgi-bin/qr2/output.png

qrencode -o "$QR_FILE" -l H -s 3 "$text"

echo "$(date +%c)|qrencode -l H -s 3 -o \"$QR_FILE\" \"$text\"" >> /tmp/qr2.log
chmod 640 "$QR_FILE" /tmp/qr2.log


# Output HTML with the generated QR code
#echo "<html><body>"
#echo "<h1>Generated QR Code</h1>"
#echo "<img src='/cgi-bin/qr2/output.png' alt='QR Code'>"
#echo "</body></html>"

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
echo "<p>$text</p>"
echo "</body>"
echo "</html>"
