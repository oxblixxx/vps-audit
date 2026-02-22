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

## 3. SSH Password Auth
While this depends on the cloud init-image that was used to create the server, to disable password auth can be in the sshd file, or the cloud init file `50-cloud-init.conf`

## 5. SSH Port

The SSH port has to bee changed to an **unprivileged port** (a port number greater than 1024) to improve security.  

- Edit `/etc/ssh/sshd_config` to modify the port manually.  
- To change the port automatically, run the provided script: [change port](fix_scripts/change_port).  

## Firewall Status

Before enabling UFW, make sure to **allow the SSH port** configured in section 5.  
This ensures you do not get locked out of the server.

- Replace `<PORT>` with your SSH port number (e.g., 2222).  
- Example command to allow the port:

```bash
sudo ufw allow <PORT>/tcp
```

Then you can run 

```sh
sudo ufw --force enable
sudo ufw status
sudo ufw allow 80
sudo ufw allow 443
```

## 6. Password Policy
To fix this, configure PAM password policy by installing & configure libpam-pwquality.

```sh
sudo apt install libpam-pwquality -y
```

Then edit the conf file

```sh
sudo nano /etc/pam.d/common-password
```

Find this line :

```sh
password       requisite                       pam_pwquality.so retry=3
password    [success=1 default=ignore]    pam_unix.so obscure sha512 rem
```
Replace with:

```sh
password    requisite           pam_pwquality.so retry=3 minlen=12 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1
password    [success=1 default=ignore]    pam_unix.so obscure sha512 remember=5
```
Then test by changing a user password:

```sh
passwd <username>
```

## 7. System Updates
To fix this, update the server

```sh
sudo apt upgrade -y
```

## 8. SUID Files
To verify the exact files listed as per the command in the script
# Run the EXACT same command as your audit script

```sh
find / -type f -perm -4000 2>/dev/null | \
grep -v -E "^/usr/bin/|^/bin/|^/sbin/|^/usr/sbin/|^/usr/lib|^/usr/libexec" | \
grep -v -E "ping$|sudo$|mount$|umount$|su$|passwd$|chsh$|newgrp$|gpasswd$|chfn$" > /tmp/suspicious-suid.txt
```
# Review the list, or export the file file out of the server to open it
```sh
cat /tmp/suspicious-suid.txt | wc -l 
less /tmp/suspicious-suid.txt
```
