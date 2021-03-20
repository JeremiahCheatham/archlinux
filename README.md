# Arch Linux Installation Guide.
## Overview
This guide will walk you through the steps needed to install a fully functional archlinux desktop system.
Both x86_64 and raspberry pi will be covered. The focus is KDE, but steps for XFCE will also be shown.
I use an install script to help me remember and automate most of the steps. There are also some config and skel files included.
I also recomend using the official Arch Linux install guide for support. I often find answers to my problems hiden there.

https://wiki.archlinux.org/index.php/Installation_guide

## Intel & AMD Download and bootable USB
### Download ISO image
The download for the latest Archlinux ISO can be found here. https://archlinux.org/download/

This is a direct link to a mirror with the latest image. https://mirrors.edge.kernel.org/archlinux/iso/latest/

### Create bootable USB
To find the name of your USB device. Use the command lsblk.

    # lsblk

All data on the USB in all partitions will be lost.
Be sure to know the name of your USB. `/dev/sdX` where X is the letter of your USB.
Be careful it is not your hard drive or ssd.
The partition `part /` is the device with your system partition. Be careful!
Check the size of the device and where the partitions if any are mounted.

We will use the cat command to write the image to the USB. Change directiory to where ever you downloaded the file.

    # cd ~/Downloads
    # cat archlinux-*-x86_64.iso > /dev/sdX

## Intel & AMD Installation
You will need to boot your system from the USB drive. It may simply need to reboot with the USB left in.
You most likely need to know how to tell your bios to boot from USB devices.
It may be something like pressing `escape`, `F5`, `F8`, `F10` or `F11` during bootup. Search your device and boot from USB.
### Set keyboard
If you are using a US keyboard you can skip this step. If you would like to see a list keyboard use this command.

    # ls /usr/share/kbd/keymaps/**/*.map.gz

Here is an example of setting the keyboard to the UK keymap.

    # loadkeys uk

### Setup Internet
If you need to setup wireless internet first find the name of your wife adapter.

    # iwctl device list | grep station | cut -f 3 -d " "

This will be your ADAPTER name. The name of your network is your SSID.
Replace ADAPTER and SSID below with there names. You will be promptered for a password to your SSID.

    # iwctl station ADAPTER connect SSID

If that was successful or you have a wired connection lets check if you're online.

    # ping archlinux.org

Update the system clock.

    # timedatectl set-ntp true

### Create Partitions
You will need to create some partitons to install archlinux on. This will perminantly destroy any data on the device.
You have been warned. I will assume you have a device that you can create partitions on.
Again any existing partitions will be destroyed along with all data held in them. Get a list of partitions.

    # fdisk -l

Edit the device with fdisk. Replace X with the device letter you are willing to loose all data on.

    # fdisk /dev/sdX


    # mkfs.fat -F32 /dev/sdX1
    # mkswap /dev/sdX2
    # mkfs.ext4 /dev/sdX3

    # mount /dev/sdX3 /mnt
    # mkdir /mnt/efi
    # mount /dev/sdX1 /mnt/efi

    # reflector
    
    # pacstrap /mnt base linux-firmware linux grub efibootmgr iwd sudo nano vim pacman-contrib htop base-devel xorg-server mesa-demos plasma plasma-wayland-session kde-applications pulseaudio-bluetooth chromium firefox python-pygame python-numpy python-wheel python-pip python-language-server ctags git
    
    # genfstab -U /mnt >> /mnt/etc/fstab

chroot

    # arch-chroot /mnt
    
    # sed -i 's/#en_GB.UTF-8/en_GB.UTF-8/' /etc/locale.gen
    # locale-gen

    # sed -i 's/# %wheel ALL=(ALL) NOPASSWD/%wheel ALL=(ALL) NOPASSWD/' /etc/sudoers

    # echo "KEYMAP=uk" > /etc/vconsole.conf
    # echo "setxkbmap gb" > /usr/share/sddm/scripts/Xsetup

    # sed -i 's/Adwaita/breeze_cursors/' /usr/share/icons/default/index.theme

    # grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/efi
    # grub-mkconfig -o /boot/grub/grub.cfg
    
    # echo $MYNAME > /etc/hostname

    # echo "127.0.0.1       localhost" > /etc/hosts
    # echo "::1             localhost" >> /etc/hosts
    # echo "127.0.0.1       $MYNAME.localdomain $MYNAME" >> /etc/hosts
    
    # useradd -m $MYNAME -G wheel
    # passwd $MYNAME
    
    # passwd
    
reboot

    # timedatectl set-timezone Europe/London
    # timedatectl set-ntp true
    # localectl set-locale LANG=en_GB.UTF-8
    # localectl set-x11-keymap gb
    # localectl set-keymap uk
    
    # systemctl enable NetworkManager
    # systemctl enable bluetooth
    # systemctl enable sddm
    
    # reboot
