# System Administration Scripts Collection

This repository contains a collection of system administration and setup scripts for various Linux distributions and Android development. The scripts are organized by distribution and purpose.

## Directory Structure

```
.
├── android/    # Android development related scripts
├── arch/       # Arch Linux specific scripts
├── debian/     # Debian specific scripts
├── fedora/     # Fedora specific scripts
├── tests/      # Test scripts for various functionalities
```

## Arch Linux Scripts (`arch/`)

- `stup`: Theme installation script for KDE and GTK
  - Clones and installs Layan KDE theme
  - Clones and installs Layan GTK theme with dark variant
  
- `stylepak`: Utility for managing GTK theme installation for Flatpak applications
- `tolightdm`: Script for switching to LightDM display manager by removing other display managers and installing LightDM
- `tosddm`: Script for switching to SDDM display manager
- `extup`: Extension update script
- `grubdown`: GRUB management and configuration script
- `keyfix`: Keyring and package signing fixes
- `ram`: Script for ranking Arch mirrors to find the fastest ones using rate-mirrors
- `rpipe`: Script for restarting PipeWire and PipeWire-Pulse audio services
- `rvm`: Script for restarting libvirtd service for virtual machines

## Debian Scripts (`debian/`)

- `qemu-setup.sh`: QEMU virtualization setup script
- `vmware-fix.sh`: Comprehensive VMware setup and fix script
  - Updates system packages
  - Installs required dependencies (build-essential, linux headers, etc.)
  - Configures and enables VMware services
  - Patches and rebuilds VMware kernel modules for the current kernel

## Fedora Scripts (`fedora/`)

- `vmmware_modules.sh`: VMware modules configuration script for Fedora

## Android Development Scripts (`android/`)

- `android_build_env.sh`: Complete Android build environment setup
  - Installs necessary development packages based on detected distribution
  - Sets up GitHub CLI
  - Configures ADB udev rules
  - Supports multiple Ubuntu/Debian versions

- `arch.sh`: Arch Linux specific Android build setup
- `ccache.sh`: Compiler cache configuration script
- `create_user.sh`: User creation utility for build environment
- `fedora.sh`: Fedora specific Android build setup
- `amke.sh`: Script to download, build and install a specific version of GNU make

## Test Scripts (`tests/`)

- `s3-test.py`: Script to test S3 connectivity and operations
  - Tests connection to an S3-compatible server
  - Creates test buckets and performs upload/download operations
  - Takes S3 credentials from environment variables or prompts for input

- `postgres-check.py`: Script to test PostgreSQL database connectivity and operations
  - Connects to PostgreSQL using database URL from environment or manual input
  - Creates test tables, inserts data, performs queries, and cleans up
  - Verifies database operations work correctly

- `dns-test.py`: Script to test DNS server performance
  - Tests response times for multiple DNS providers (Google, Cloudflare, Quad9, etc.)
  - Measures query response times and identifies the fastest DNS server
  - Reports detailed performance metrics for each DNS server

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
- Python test scripts may require specific packages (boto3, psycopg2, dnspython)

## Note

- Always review scripts before running them
- Some scripts may modify system configuration
- Backup important data before running system modification scripts
- Check script contents for specific requirements and dependencies
