#!/bin/bash

# this script download the appropriate VMware modules version.

dir="/home/rama/scripts/vmware-host-modules"
VMWARE_VERSION=$(cat /etc/vmware/config | grep player.product.version | sed '/.*\"\(.*\)\".*/ s//\1/g')

# Check the VMware software version
[ -z VMWARE_VERSION ] && exit 0

# Check if an existing folder is already in the system and delete it if so
if [[ -d $dir ]]; then
    echo "Deleting existing vmware-host-modules folder ..."
    rm -rf ~/Shared/Scripts/vmware-host-modules
else
    echo "Downloading new vmware modules ..."
    sleep 2
fi

# Download the Git repo with VMware kernel modules
git clone -b workstation-${VMWARE_VERSION} https://github.com/mkubecek/vmware-host-modules.git

echo "Final Step ..."
sleep 2
# Install the VMware kernel modules
cd $dir && make && sudo make install
echo "Done ..."
sleep 2
sleep 2
echo "Cleaning up folders"
cd ../
rm -rf vmware-host-modules
echo "Done ..."
exit 0
