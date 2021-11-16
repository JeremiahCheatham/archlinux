#!/bin/sh

clear
echo "From Install Image"
echo ""
echo "1 Set UK Keyboard and Time"
echo "2 Connect to the Internet."
echo "3 Format and mount partitions."
echo ""
echo "4 Install Archlinux KDE with pacstrap."
echo "5 Install Archlinux XFCE with pacstrap."
echo "6 Copy install-arch.sh to /mnt/root, enter chroot."
echo ""
echo "In Chroot environment."
echo "7 Set the locales."
echo "8 Set the hostname."
echo "9 Create a user."
echo "10 Set root password."
echo ""
echo "After reboot."
echo "11 Double Check Locale Keyboard and Time."
echo "12 Enable KDE services."
echo "13 Install Pygame Zero."
echo ""
echo "14 Quit"

read CHOICE

if [ $CHOICE -eq 1 ]; then
    if loadkeys uk; then
        echo "Success! Keyboard set to UK."
        if ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime; then
            echo "Success! Timezone set to Europe/London."
            if hwclock --systohc; then
                echo "Success! Hardware Clock Updated."
            else
                echo "Failed! Hardware Clock not Updated."
            fi
        else
            echo "Failed! Timezone not set to Europe/London."
        fi
    else
        echo "Failed! Keyboard not set to UK."
    fi
fi
if [ $CHOICE -eq 2 ]; then
    WIFI=$( iwctl device list | grep station | cut -f 3 -d " " )
    if [ -n "$WIFI" ]; then
        iwctl station $WIFI connect "SKY39WTW 5G"
        sleep 5
        if ! $( ping -c 1 google.com 1>/dev/null ); then
            echo "Network Not Connected!"
        else
            echo "Network Connected."
        fi
    else
        echo "No Wireless Device Found"
    fi
fi
if [ $CHOICE -eq 3 ]; then
    lsblk
    echo "Input root partitions like /dev/sda2"
    read ROOTP
    if mkfs.ext4 $ROOTP; then
        echo "Success! $ROOTP formatted."
        if mount $ROOTP /mnt; then
            echo "Success! $ROOTP mounted on /mnt."
            if mkdir /mnt/boot/efi; then
                echo "Success! /mnt/boot/efi directory created."
                echo "Input boot partitions like /dev/sda1"
                read BOOTP
                echo "Format $BOOTP or leave intacted y/n?"
                read BOOTPF
                if [ $BOOTPF = [Yy] ]; then
                    if mkfs.fat -F32 $BOOTP; then
                        echo "Success! $BOOTP formatted."
                    else
                        echo "Failed! $BOOTP not formatted."
                    fi
                fi
                if mount $BOOTP /mnt/boot/efi; then
                    echo "Success! $BOOTP mounted on /mnt/boot/efi."
                else
                    echo "Failed! $BOOTP not mounted on /mnt/boot/efi."
                fi
            else
                echo "Failed! /mnt/boot/efi directory not created."
            fi
        else
            echo "Failed! $ROOTP not mounted on /mnt."
        fi
    else
        echo "Failed! $ROOTP not formatted."
    fi
fi
if [ $CHOICE -eq 4 ]; then
    if reflector; then
        echo "Success! Mirrors updated."
        if pacstrap /mnt base linux-firmware linux grub efibootmgr iwd sudo nano vim pacman-contrib htop base-devel xorg-server mesa-demos plasma plasma-wayland-session kde-applications autopep8 chromium ctags firefox flake8 git hunspell-en_gb pulseaudio-bluetooth python-jedi python-language-server python-mccabe python-numpy python-pip python-pycodestyle python-pydocstyle python-pyflakes python-pygame python-pylint python-rope python-wheel yapf; then
            echo "Success! Archlinux KDE installed."
            if genfstab -U /mnt >> /mnt/etc/fstab; then
                echo "Success! Fstab updated."
            else
                echo "Failed! Fstab not updated."
            fi
        else
            echo "Failed! Archlinux KDE not installed."
        fi
    else
        echo "Failed! Mirrors not updated."
    fi
fi
if [ $CHOICE -eq 5 ]; then
    if reflector; then
        echo "Success! Mirrors updated."
        if pacstrap /mnt base linux-firmware linux grub efibootmgr iwd sudo nano vim pacman-contrib htop base-devel xorg-server mesa-demos xfce xfce-goodies lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings file-roller gvfs network-manager-applet atril galculator drawing geany geany-plugins xdg-user-dirs-gtk pulseaudio pavucontrol adobe-source-sans-pro-fonts adobe-source-code-pro-fonts gnu-free-fonts ttf-hack noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-roboto autopep8 chromium ctags firefox flake8 git hunspell-en_gb python-jedi python-language-server python-mccabe python-numpy python-pip python-pycodestyle python-pydocstyle python-pyflakes python-pygame python-pylint python-rope python-wheel yapf; then
            echo "Success! Archlinux XFCE installed."
            if genfstab -U /mnt >> /mnt/etc/fstab; then
                echo "Success! Fstab updated."
            else
                echo "Failed! Fstab not updated."
            fi
        else
            echo "Failed! Archlinux XFCE not installed."
        fi
    else
        echo "Failed! Mirrors not updated."
    fi
fi
if [ $CHOICE -eq 6 ]; then
    if cp ./$(basename $0) /mnt/root; then
        echo "Success! $(basename $0) copied to /mnt/root."
        arch-chroot /mnt
    else
        echo "Failed! $(basename $0) not copied to /mnt/root."
    fi
fi
if [ $CHOICE -eq 7 ]; then
    if sed -i 's/#en_GB.UTF-8/en_GB.UTF-8/' /etc/locale.gen; then
        echo "Success! Uncommented en_GB.UTF-8 in /etc/locale.gen."
        if locale-gen; then
            echo "Success! Generated Locale."
            if sed -i 's/# %wheel ALL=(ALL) NOPASSWD/%wheel ALL=(ALL) NOPASSWD/' /etc/sudoers; then
                echo "Success! Uncommented wheel in /etc/sudoers."
                if echo "KEYMAP=uk" > /etc/vconsole.conf; then
                    echo "Success! Added KEYMAP to /etc/vconsole.conf"
                    if echo "setxkbmap gb" > /usr/share/sddm/scripts/Xsetup; then
                        echo "Success! Added setxkbmap gb to /usr/share/sddm/scripts/Xsetup."
                        if sed -i 's/Adwaita/breeze_cursors/' /usr/share/icons/default/index.theme; then
                            echo "Success! Set breeze_cursors in /usr/share/icons/default/index.theme."
                            if grub-install --target=x86_64-efi --bootloader-id=archlinux --efi-directory=/boot/efi; then
                                echo "Success! Installed Grub."
                                if grub-mkconfig -o /boot/grub/grub.cfg; then
                                    echo "Success! Grub Configued."
                                else
                                    echo "Failed! Couldn't configure Grub"
                                fi
                            else
                                echo "Failed! Couldn't install Grub."
                            fi
                        else
                            echo "Failed! Couldn't set breeze_cursors in /usr/share/icons/default/index.theme."
                        fi
                    else
                        echo "Failed! Couldn't add setxkbmap gb to /usr/share/sddm/scripts/Xsetup."
                    fi
                else
                    echo "Failed! Couldn't add KEYMAP to /etc/vconsole.conf."
                fi
            else
                echo "Failed! Couldn't uncommented wheel in /etc/sudoers."
            fi
        else
            echo "Failed! Couldn't Generate locale."
        fi
    else
        echo "Failed! Couldn't uncommented en_GB.UTF-8 in /etc/locale.gen."
    fi
fi
if [ $CHOICE -eq 8 ]; then
    echo "Enter your hostname."
    read MYNAME
    if echo $MYNAME > /etc/hostname; then
        echo "Success! Set hostname."
        if echo "127.0.0.1       localhost" > /etc/hosts; then
            if echo "::1             localhost" >> /etc/hosts; then
                if echo "127.0.0.1       $MYNAME.localdomain $MYNAME" >> /etc/hosts; then
                    echo "Success! Setup /etc/hosts"
                else
                    echo "Failed! Couldn't setup /etc/hosts"
                fi
            fi
        fi
    else
        echo "Failed! Couldn't set hostname."
    fi
fi
if [ $CHOICE -eq 9 ]; then
    echo "Enter your user name."
    read MYNAME
    if useradd -m $MYNAME -G wheel; then
        echo "Success! user $MYNAME added."
        if passwd $MYNAME; then
            echo "Success! password for $MYNAME set."
        else
            echo "Failed! password for $MYNAME not set."
        fi
    else
        echo "Failed! user $MYNAME was not added."
    fi
fi
if [ $CHOICE -eq 10 ]; then
    if passwd; then
        echo "Success! Root password set."
    else
        echo "Failed! Root password not set."
    fi
fi
if [ $CHOICE -eq 11 ]; then
    if timedatectl set-timezone Europe/London; then
        echo "Success! Europ/London Timezone set."
        if timedatectl set-ntp true; then
            echo "Success! set-ntp true."
            if localectl set-locale LANG=en_GB.UTF-8; then
                echo "Success! Locale set to en_GB.UTF-8"
                if localectl set-x11-keymap gb; then
                    echo "Success! X11 keymap set to gb."
                    if localectl set-keymap uk; then
                        echo "Success! keymap set to uk."
                    else
                        echo "Failed! Keymap set to uk."
                    fi
                else
                    echo "Failed! X11 keymap not set to gb."
                fi
            else
                echo "Failed! Locale not set to en_GB.UTF-8"
            fi
        else
            echo "Failed! set-ntp true not set."
        fi
    else
        echo "Failed! Europ/London Timezone not set."
    fi
fi
if [ $CHOICE -eq 12 ]; then
    if systemctl enable NetworkManager; then
        echo "Success! NetworkManager enabled."
        if systemctl enable bluetooth; then
            echo "Success! bluetooth enabled."
            if systemctl enable sddm; then
                echo "Success! Sddm enabled."
            else
                echo "Failed! Sddm not enabled."
            fi
        else
            echo "Failed! bluetooth not enabled."
        fi
    else
        echo "Failed! NetworkManager not enabled."
    fi
fi
if [ $CHOICE -eq 13 ]; then
    if pip install git+https://github.com/lordmauve/pgzero.git --no-deps --upgrade; then
        echo "Success! Pygame Zero installed."
        if pip install pyfxr; then
            echo "Success! pyfxr module installed."
        else
            echo "Failed pyfxr module not installed."
        fi
    else
        echo "Failed! Pygame Zero not isntalled."
    fi
fi
if [ $CHOICE -eq 14 ]; then
    exit
fi

read
./$(basename $0) && exit
