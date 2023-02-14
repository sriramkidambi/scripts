sudo pacman -Sy
sudo pacman -S --needed git base-devel
git clone  https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si

yay -S google-chrome brave-bin discord ferdium-bin bitwarden-desktop guilded


