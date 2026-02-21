#!/bin/bash
# ----------------------------
# Script: firewall_setup.sh
# Purpose: Allow SSH, HTTP, and HTTPS ports and enable UFW safely
# ----------------------------

# ===== CONFIGURATION =====
SSH_PORT=2222  # Replace with your current SSH port

# 1️⃣ Allow necessary ports
sudo ufw allow "$SSH_PORT"/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
echo "✅ Allowed TCP ports: $SSH_PORT, 80, 443"

# 3️⃣ Enable UFW
sudo ufw --force enable
echo "✅ UFW enabled"

# 4️⃣ Show UFW status
sudo ufw status verbose
