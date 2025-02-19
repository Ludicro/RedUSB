#!/bin/bash
echo -e "\e[91m[!] Checking USB drive...\e[0m"
sleep 2

# Find USB drive by checking mounted devices
USB_MOUNT=$(lsblk -o NAME,LABEL,MOUNTPOINT | grep "RedUSB" | awk '{print $3}')

if [ -z "$USB_MOUNT" ]; then
    echo -e "\e[91m[!] No RedUSB drive found\e[0m"
    exit 1
fi

echo -e "\e[91m[!] RedUSB drive found at: $USB_MOUNT\e[0m"
echo -e "\e[91m[!] Updating USB contents...\e[0m"

# Copy contents from USB directory to drive root
cp -r USB/* "$USB_MOUNT/"

echo -e "\e[91m[!] USB contents updated successfully\e[0m"
sleep 3


# I haven't tested this yet