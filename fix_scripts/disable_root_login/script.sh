#!/bin/bash
# ----------------------------
# Script: disable_root_ssh.sh
# Purpose: Disable root login over SSH safely
# ----------------------------

# Backup SSH config
SSH_CONF="/etc/ssh/sshd_config"
BACKUP="/etc/ssh/sshd_config.bak.$(date +%F_%T)"
sudo cp "$SSH_CONF" "$BACKUP"
echo "✅ Backup of SSH config created at $BACKUP"

# Disable root login
sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' "$SSH_CONF"
echo "✅ Root login disabled in $SSH_CONF"

# Restart SSH service
sudo systemctl restart sshd
echo "✅ SSH service restarted"

# Verify
grep -i "^PermitRootLogin" "$SSH_CONF"
echo "✅ Done. Root login over SSH is now disabled."
