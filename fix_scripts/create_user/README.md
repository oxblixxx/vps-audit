# User Creation Script

This script reads usernames from `random_names.csv`, creates each user with a random password, generates an SSH key pair, and adds them to the sudo group.  

- The **private SSH key** is saved in the `cred_folder`.  
- The **public key** is automatically added to the user's `authorized_keys`.

Make the file executable, then run it!
