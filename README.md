# System Administration Scripts Collection

This repository contains a collection of system administration and setup scripts for various Linux distributions and Android development. The scripts are organized by distribution and purpose.

## Directory Structure

```
.
├── android/    # Android development related scripts
├── arch/       # Arch Linux specific scripts
├── debian/     # Debian specific scripts
└── fedora/     # Fedora specific scripts
```

## Arch Linux Scripts (`arch/`)

- `stup`: Theme installation script for KDE and GTK
  - Installs Layan KDE theme
  - Installs Layan GTK theme with dark variant
  
- `stylepak`: Manages GTK theme installation for Flatpak applications (150 lines)
- `tolightdm`: Script for switching to LightDM display manager
- `tosddm`: Script for switching to SDDM display manager
- `extup`: Extension update script
- `grubdown`: GRUB management and configuration script
- `keyfix`: Keyring and package signing fixes
- `ram`: RAM management utility
- `rpipe`: Pipeline utility script
- `rvm`: Ruby Version Manager setup script

## Debian Scripts (`debian/`)

- `qemu-setup.sh`: QEMU virtualization setup script
- `vmware-fix.sh`: Comprehensive VMware setup and fix script
  - Updates system packages
  - Installs required dependencies
  - Configures VMware services
  - Patches kernel modules
  - Rebuilds VMware modules for current kernel

## Fedora Scripts (`fedora/`)

- `vmmware_modules.sh`: VMware modules configuration script for Fedora

## Android Development Scripts (`android/`)

- `android_build_env.sh`: Complete Android build environment setup
  - Installs necessary development packages
  - Sets up GitHub CLI
  - Configures ADB udev rules
  - Installs repo tool
  - Supports multiple Ubuntu/Debian versions

- `arch.sh`: Arch Linux specific Android build setup
- `ccache.sh`: Compiler cache configuration
- `create_user.sh`: User creation utility for build environment
- `fedora.sh`: Fedora specific Android build setup
- `amke.sh`: Android make utility script

## Usage

Most scripts can be executed directly after making them executable:

```bash
chmod +x script_name
./script_name
```

## Requirements

- Different scripts may require root privileges (sudo)
- Scripts are distribution-specific, please use them with the appropriate Linux distribution
- Some scripts may require internet connection for downloading packages and resources

## Note

- Always review scripts before running them
- Some scripts may modify system configuration
- Backup important data before running system modification scripts
- Check script contents for specific requirements and dependencies 
