#!/bin/bash

id=$((${RANDOM} % 1000))

# Set the upload directory
UPLOAD_DIR="/tmp/uploads_${id}"

# Create the upload directory if it doesn't exist
mkdir -p "$UPLOAD_DIR"

# Check if a file was uploaded
if [ -z "$CONTENT_LENGTH" ]; then
    echo "No file uploaded."
    exit 1
fi

# Save the uploaded file
cat > "$UPLOAD_DIR/uploaded_file.pdf"

# Check the file size
file_size=$(stat -c%s "$UPLOAD_DIR/uploaded_file.pdf")

# Set the max allowed size in bytes (e.g., 10MB)
max_size=$((5 * 1024 * 1024))

if [ $file_size -gt $max_size ];then
    echo "Content-type: text/html"
    echo ""
    echo "File too large."
    rm "$UPLOAD_DIR/uploaded_file.pdf"
    rmdir "$UPLOAD_DIR"
    exit 1
fi

# Convert the PDF to JPG
#timeout 600 magick convert -density 150 "$UPLOAD_DIR/uploaded_file.pdf" -quality 90 -background white -alpha remove "$UPLOAD_DIR/output_%03d.jpg"
#timeout 600 magick -density 150 "$UPLOAD_DIR/uploaded_file.pdf" -quality 90 -background white -alpha remove -resize "50%" "$UPLOAD_DIR/output_%03d.jpg"
#resources usage - resize=more ram needed,around 50%
timeout 900 magick -density 150 "$UPLOAD_DIR/uploaded_file.pdf" -quality 90 -background white -alpha remove "$UPLOAD_DIR/output_%03d.jpg"

# Output HTML to display the images
echo "Content-type: text/html"
echo ""

# HTML to display the images
echo "<html><head><title>Converted Images</title></head><body>"
echo "<h2>Converted Images:</h2>"

# Loop through the images and display them
for file in "$UPLOAD_DIR/output_"*.jpg; do
    echo "<img src='data:image/jpeg;base64,$(base64 "$file")' alt='Converted Image'>"
done

echo "</body></html>"

rm -rf "$UPLOAD_DIR"
