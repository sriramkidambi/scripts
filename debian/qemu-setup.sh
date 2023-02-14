#!/bin/bash

# Display ASCII art
echo "         _nnnn_                       "
echo "        dGGGGMMb     ,\"\"\"\"\"\"\"\"\"\"\"."
echo "       @p~qp~~qMb    | Installing QEMU |"
echo "       M|@||@) M|   _;..............'"
echo "       @,----.JM| -'"
echo "      JS^\__/  qKL"
echo "     dZP        qKRb"
echo "    dZP          qKKb"
echo "   fZP            SMMb"
echo "   HZM            MMMM"
echo "   FqM            MMMM"
echo " __| \".        |\\dS\"qML"
echo " |    \`.       | \`' \\Zq"
echo "_)      \\.___.,|     .'"
echo "\\____   )MMMMMM|   .'"
echo "     \`-'       \`--' hjm"
sudo apt install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager -y
sudo virsh net-start default
sudo virsh net-autostart default
sudo usermod -aG libvirt $USER
sudo usermod -aG libvirt-qemu $USER
sudo usermod -aG kvm $USER
sudo usermod -aG input $USER
sudo usermod -aG disk $USER