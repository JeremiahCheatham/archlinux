#!/bin/bash

# let /etc/sudoers and wheel handle permission.
sudo sed -i 's/# %wheel ALL=(ALL:ALL) NOPASSWD/%wheel ALL=(ALL:ALL) NOPASSWD/' /etc/sudoers
sudo sh -c "rm /etc/sudoers.d/00_*"

# Enable ParallelDownloads.
sudo sed -i 's/#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf

# Add pacman tools, btrfs tools and ntfs support.
sudo pacman -S pacman-contrib compsize ntfs-3g

# Enable Bluetooth.
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

# Configure zram with lz4 compression and double ram size.
sudo cat << EOF > /etc/systemd/zram-generator.conf
[zram0]
compression-algorithm = lz4
zram-size = ram * 2
EOF

sudo systemctl restart systemd-zram-setup@zram0.service

# Prevent pcspkr beeping
sudo rmmod pcspkr
echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/nobeep.conf

# Let firefox use wayland when in a wayland session.
sudo sh -c "cat << EOF >> /etc/profile

# Enable Wayland for Firefox when needed.
if [ "$XDG_SESSION_TYPE" == "wayland" ]; then
    export MOZ_ENABLE_WAYLAND=1
fi
EOF
"

# Install code, firefox, gcompris-qt, kde applications, krita and add vlc backend to phonon.
sudo pacman -S --needed code firefox gcompris-qt kde-applications krita phonon-qt5-vlc
