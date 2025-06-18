#!/bin/bash

# Source file
SOURCE_FILE="~/handsomeware/handsomeware-notes.txt"

# Destination directory
DEST_DIR="/home"

# Generate 20 random filenames and copy the file
for i in {1..20}; do
    RANDOM_NAME=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 8)
    DEST_FILE="${DEST_DIR}/${RANDOM_NAME}.README.txt"
    cp "$SOURCE_FILE" "$DEST_FILE"
done

echo "Done. Copied to 20 random files in /home/"