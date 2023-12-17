#!/bin/bash

# Hide commands being run
set -e
set +x

# Display ASCII penguin with waiting sign
whiptail --title "KVM Installation" --infobox "Installing KVM, please wait..." 10 50

# Install KVM packages
apt-get update
apt-get install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst

# Enable and start libvirtd service
systemctl enable libvirtd
systemctl start libvirtd

# Add user to the libvirt group
usermod -aG libvirt $(whoami)

# Display completion message
whiptail --title "KVM Installation" --msgbox "KVM installation and configuration completed successfully!" 10 50
