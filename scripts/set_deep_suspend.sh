#!/bin/bash

# Manual Procedure
# sudo apt install gnome-screenshot
# nano ~/.local/share/applications/gnome-screenshot-legacy.desktop
# (paste desktop entry from below)
# chmod +x ~/.local/share/applications/gnome-screenshot-legacy.desktop

# Check if we're running as root, exit if not
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root!"
    exit 1
fi

### TODO: test

# Specify the target user
TARGET_USER="adambowen"  # Replace with your user

# Manually set $USER and $HOME
export USER=$TARGET_USERsz
export HOME=/home/$TARGET_USER

###

# Path to GRUB config
GRUB_CONF="/etc/default/grub"

# Backup GRUB configuration file before editing
cp $GRUB_CONF ${GRUB_CONF}.bak

# Modify GRUB_CMDLINE_LINUX_DEFAULT to include mem_sleep_default=deep
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 mem_sleep_default=deep"/' $GRUB_CONF

# Update GRUB
echo "Updating GRUB..."
update-grub

# Confirm the change was applied
if grep -q "mem_sleep_default=deep" $GRUB_CONF; then
    echo "GRUB config updated successfully. Please reboot your system for changes to take effect."
else
    echo "Failed to update GRUB config."
    exit 1
fi

# Reboot system
echo "Rebooting now..."
reboot
