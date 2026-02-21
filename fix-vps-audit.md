# System Audit Remediation Actions

## 1. System Restart

To resolve this issue, ensure the server is not actively in use before proceeding.  
It is recommended to schedule the restart during a maintenance window to avoid disrupting business operations.

---

### Immediate Restart

```sh
sudo reboot
```

### Scheduled Restart (Using at)

If you prefer to schedule the restart at a specific time:

Step 1: Install and Enable at (if not already installed)

```SH
sudo apt install at -y
sudo systemctl enable --now atd
```

Step 2: Schedule the Reboot

Example: Schedule reboot for 11:30 PM

```sh
echo "sudo reboot" | at 23:30
```

Note: Adjust 23:30 to your desired time using 24-hour format.

## 2. SSH Root Login
> **Important:** Before disabling SSH root login:
> 
> 1. Make sure a non-root [user](fix_scripts/create_user) has been created.  
> 2. Ensure the user has **sudo/root privileges**.  
> 3. Copy the user’s **public SSH key** to their `authorized_keys`.  
> 4. Test logging in as the new user to confirm access works.
> 5. Run the scripts to [remove root login](fix_scripts/disable_root_login).


