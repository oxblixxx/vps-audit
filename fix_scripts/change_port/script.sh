#!/bin/bash
# ----------------------------
# Script: change_ssh_port_direct.sh
# Purpose: Change SSH port by editing /etc/ssh/sshd_config directly
# ----------------------------

# ===== CONFIGURATION =====
NEW_PORT=27736            # Change this to any port > 1024
SSH_CONF="/etc/ssh/sshd_config"

# 1️⃣ Backup original sshd_config
BACKUP="/etc/ssh/sshd_config.bak.$(date +%F_%T)"
sudo cp "$SSH_CONF" "$BACKUP"
echo "✅ Backup of sshd_config created at $BACKUP"

# 2️⃣ Change or add the Port line
#if grep -q "^Port" "$SSH_CONF"; then
#    sudo sed -i "s/^Port.*/Port $NEW_PORT/" "$SSH_CONF"
if grep -qE "^\s*#?\s*Port\s+" "$SSH_CONF"; then
    # Replace any Port line (commented or uncommented)
    sudo sed -i "s|^\s*#\?\s*Port\s\+.*|Port $NEW_PORT|" "$SSH_CONF"

else
    echo "Port $NEW_PORT" | sudo tee -a "$SSH_CONF" >/dev/null
fi
echo "✅ SSH port set to $NEW_PORT in $SSH_CONF"

# 4️⃣ Restart SSH service
sudo systemctl restart sshd
echo "✅ SSH service restarted"

# 5️⃣ Verify the new port
grep "^Port" "$SSH_CONF"
echo "✅ Done. Test your SSH connection with:"
