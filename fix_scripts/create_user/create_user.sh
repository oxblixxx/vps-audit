#!/bin/bash
# ----------------------------
# Script: create_users_with_ssh_sudo.sh
# Purpose: Create users from CSV, generate SSH keys, add to sudo, save credentials
# ----------------------------

# Input file with raw names
input="random_names.csv"
# Output file with cleaned usernames
user_file="usernames.txt"
# Directory to store credentials
cred_dir="user_credentials"

mkdir -p "$cred_dir"
chmod 700 "$cred_dir"

# Generate valid Linux usernames:
#  - lowercase
#  - spaces → underscores
#  - remove carriage returns
#  - remove duplicates
cat "$input" \
  | sed 's/^[ \t]*//;s/[ \t]*$//' \
  | tr '[:upper:]' '[:lower:]' \
  | tr ' ' '_' \
  | tr -d '\r' \
  | sort -u > "$user_file"

# Loop through usernames and create users
while read -r username; do
    # Generate a random password
    password=$(openssl rand -hex 8)

    if id "$username" &>/dev/null; then
        echo "User '$username' already exists. Skipping..."
    else
        echo "Creating user: $username"

        # 1️⃣ Create user non-interactively
        sudo adduser "$username" --home /home/$username --gecos "" &>/dev/null

        # 2️⃣ Set password
        echo "$username:$password" | sudo chpasswd

        # 3️⃣ Add user to sudo group
        sudo usermod -aG sudo "$username"

        # 4️⃣ Create .ssh directory
        USER_HOME="/home/$username"
        sudo mkdir -p "$USER_HOME/.ssh"
        sudo chmod 700 "$USER_HOME/.ssh"
        sudo chown "$username:$username" "$USER_HOME/.ssh"

        # 5️⃣ Generate SSH key pair (no passphrase)
        sudo -u "$username" ssh-keygen -t rsa -b 4096 -f "$USER_HOME/.ssh/id_rsa" -N "" < /dev/null &>/dev/null

        # 6️⃣ Add public key to authorized_keys
        sudo -u "$username" tee -a "$USER_HOME/.ssh/authorized_keys" < "$USER_HOME/.ssh/id_rsa.pub" &>/dev/null
#        sudo -u "$username" bash -c "cat $USER_HOME/.ssh/id_rsa.pub >> $USER_HOME/.ssh/authorized_keys"
        sudo chmod 600 "$USER_HOME/.ssh/authorized_keys"
        sudo chown "$username:$username" "$USER_HOME/.ssh/authorized_keys"

        # 7️⃣ Save credentials to files
        echo "Password: $password" > "$cred_dir/${username}_credentials.txt"
        sudo cp "$USER_HOME/.ssh/id_rsa" "$cred_dir/${username}_private_key.pem"
        sudo chown $(whoami):$(whoami) "$cred_dir/${username}_private_key.pem"
        chmod 600 "$cred_dir/${username}_private_key.pem"

        echo "✅ User $username created. Credentials saved in $cred_dir/"
        echo "----------------------------------------"
    fi

    sleep 1
done < "$user_file"
