#!/bin/bash

# Exit on any error
set -euo pipefail

# Function to check if a package is installed
check_and_install() {
    PACKAGE=$1
    if ! dpkg-query -W -f='${Status}' "$PACKAGE" 2>/dev/null | grep -q "install ok installed"; then
        echo "$PACKAGE is not installed. Installing..."
        sudo apt-get install -y "$PACKAGE"
    else
        echo "$PACKAGE is already installed."
    fi
}

# Update and upgrade system
echo "Updating system packages..."
sudo apt-get update && sudo apt-get full-upgrade -y

# Check for required packages and install if missing
REQUIRED_PACKAGES=("curl" "libaio1" "build-essential" "linux-headers-$(uname -r)" "vlan" "git" "make" "gcc" "dkms" "linux-headers-generic")
for PACKAGE in "${REQUIRED_PACKAGES[@]}"; do
    check_and_install "$PACKAGE"
done

# Check if VMware services are enabled and running
if systemctl list-unit-files | grep -q "vmware.service"; then
    if ! systemctl is-enabled --quiet vmware; then
        echo "Enabling VMware services..."
        sudo systemctl enable vmware
    fi

    if ! systemctl is-active --quiet vmware; then
        echo "Starting VMware services..."
        sudo systemctl start vmware
    fi
else
    echo "VMware services not found. Skipping service enablement and start."
fi

# Get VMware version and patch kernel modules if needed
if [ -f "/etc/vmware/config" ]; then
    VMWARE_VERSION=$(grep -oP 'player.product.version.*"\K[^"]+' /etc/vmware/config)
    if [ -n "$VMWARE_VERSION" ]; then
        echo "Detected VMware version: $VMWARE_VERSION"
        echo "Patching VMware modules to support current kernel..."
        sudo rm -rf /opt/vmware-host-modules/
        if sudo git clone -b workstation-"$VMWARE_VERSION" https://github.com/mkubecek/vmware-host-modules.git /opt/vmware-host-modules/; then
            cd /opt/vmware-host-modules/ || exit 1
            sudo make
            sudo make install
        else
            echo "Failed to clone vmware-host-modules repository"
            exit 1
        fi
    else
        echo "Could not determine VMware version"
    fi
else
    echo "VMware config file not found"
fi

# Rebuild VMware kernel modules
sudo vmware-modconfig --console --install-all

# Final message
echo "VMware installation and setup complete. Please reboot your system to ensure all changes take effect."
