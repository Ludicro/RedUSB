#!/bin/bash

# Stop SSH service
echo "Stopping SSH service..."
sudo systemctl stop ssh

# Remove OpenSSH server package
echo "Removing OpenSSH server package..."
sudo apt-get remove --purge -y openssh-server

# Remove system-wide SSH configuration files
echo "Removing system-wide SSH configuration files..."
sudo rm -rf /etc/ssh

# Remove user-specific SSH keys for all users
echo "Removing user-specific SSH keys for all users..."
for user in $(cut -f1 -d: /etc/passwd); do
    if [ -d "/home/$user/.ssh" ]; then
        echo "Removing SSH keys for user: $user"
        sudo rm -rf "/home/$user/.ssh/*"
    fi
done

# Clear SSH logs (Optional)
echo "Clearing SSH logs..."
sudo truncate -s 0 /var/log/auth.log

# Remove entries from /etc/hosts.allow and /etc/hosts.deny (if any)
echo "Removing entries from /etc/hosts.allow and /etc/hosts.deny..."
if [ -f /etc/hosts.allow ]; then
    sudo cp /etc/hosts.allow /etc/hosts.allow.bak
    sudo sed -i '/sshd/d' /etc/hosts.allow
fi
if [ -f /etc/hosts.deny ]; then
    sudo cp /etc/hosts.deny /etc/hosts.deny.bak
    sudo sed -i '/sshd/d' /etc/hosts.deny
fi

# Reboot system
echo "Rebooting system..."
sudo reboot
