#!/bin/fish

# Check ParallelDownloads is enabled.
if grep -R "^ParallelDownloads" /etc/pacman.conf > /dev/null
    echo "Cool ParallelDownloads is already enabled."
else
    echo "Enabling ParallelDownloads."
    sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
end

# Check these packages are installed.
set PACKAGES alsa-utils light notification-daemon haskell-language-server bash-language-server firefox gnome-keyring

for i in $PACKAGES
    if pacman -Q $i > /dev/null 2>&1
        echo "Cool $i is already installed."
    else
        echo "Installing $i."
        sudo pacman -S $i
    end
end

# You need to be in Video group for light to change screen brightness.
if groups | grep video > /dev/null
    echo "Cool you're already in the video group."
else
    echo "Adding you to video group. A restart will be needed."
    sudo usermod -a -G video $USER
end

# Add keybindings for screen brightness.
if grep -R "XF86MonBrightnessUp" ~/.xmonad/xmonad.hs > /dev/null
    echo "Cool XF86MonBrightnessUp is already in xmonad.hs."
else
    echo "Adding XF86MonBrightnessUp to xmonad.hs"
    sed -i '/XF86AudioPlay/i\        , ("<XF86MonBrightnessUp>", spawn "light -A 5")' ~/.xmonad/xmonad.hs
end

if grep -R "XF86MonBrightnessDown" ~/.xmonad/xmonad.hs > /dev/null
    echo "Cool XF86MonBrightnessDown is already in xmonad.hs."
else
    echo "Adding XF86MonBrightnessDown to xmonad.hs"
    sed -i '/XF86AudioPlay/i\        , ("<XF86MonBrightnessDown>", spawn "light -U 5")' ~/.xmonad/xmonad.hs
end

# Launch notification-daemon
if grep -R "/usr/lib/notification-daemon-1.0/notification-daemon" ~/.xmonad/xmonad.hs > /dev/null
    echo "Cool notification-daemon is already in xmonad.hs."
else
    echo "Adding notification-daemon to xmonad.hs"
    sed -i '/spawnOnce "picom"/i\    spawnOnce "/usr/lib/notification-daemon-1.0/notification-daemon"' ~/.xmonad/xmonad.hs
end

# Let KDE/QT5 and GTK apps use the KDE theme and font.
if grep -R "XDG_CURRENT_DESKTOP=KDE" /etc/environment > /dev/null
    echo "Cool XDG_CURRENT_DESKTOP=KDE is already in /etc/environment."
else
    echo "Adding XDG_CURRENT_DESKTOP=KDE to /etc/environment."
    sudo fish -c "echo 'XDG_CURRENT_DESKTOP=KDE' >> /etc/environment"
end

# Make sure firefox is the default browser.
if grep -R "qutebrowser" ~/.xmonad/xmonad.hs > /dev/null
    echo "Replace qutebrowser with firefox in xmonad.hs"
    sed -i 's/qutebrowser/firefox/' ~/.xmonad/xmonad.hs
else
    echo "Cool firefox already replaced qutebrowser in xmonad.hs"
end

# If pulse is installed add the alsa package so it mutes and unmutes correctly.
if pacman -Q pulseaudio > /dev/null 2>&1
    echo "Pulse Audio found...."
    if pacman -Q pulseaudio-alsa > /dev/null 2>&1
        echo "Cool pulseaudio-alsa is already installed."
    else
        echo "Installing pulseaudio-alsa."
        sudo pacman -S pulseaudio-alsa
    end
    if grep -R "amixer -D pulse set Master toggle" ~/.xmonad/xmonad.hs > /dev/null
        echo "Cool amixer -D pulse set Master toggle is already in xmonad.hs"
    else
        echo "Updating amixer mute toggle with pulse in xmonad.hs"
        sed -i 's/amixer set Master toggle/amixer -D pulse set Master toggle/' ~/.xmonad/xmonad.hs
    end
else
    echo "Skipping pulse audio."
end

# Add touch pad support with tapping and NaturalScrolling.
if [ -f /etc/X11/xorg.conf.d/30-touchpad.conf ]
    echo "Cool found /etc/X11/xorg.conf.d/30-touchpad.conf"
else
    echo "Generate /etc/X11/xorg.conf.d/30-touchpad.conf"
    echo 'Section "InputClass"' >> 30-touchpad.conf
    echo '	Identifier "touchpad"' >> 30-touchpad.conf
    echo '	Driver "libinput"' >> 30-touchpad.conf
    echo '	MatchIsTouchpad "on"' >> 30-touchpad.conf
    echo '	Option "Tapping" "on"' >> 30-touchpad.conf
    echo '	Option "TappingButtonMap" "lrm"' >> 30-touchpad.conf
    echo '	Option "NaturalScrolling" "true"' >> 30-touchpad.conf
    echo 'EndSection' >> 30-touchpad.conf
    sudo chown root 30-touchpad.conf
    sudo mv 30-touchpad.conf /etc/X11/xorg.conf.d/
end

set BINS clock dtos-colorscheme dtos-help kernel memory pacupdate upt volume
for i in $BINS
    if [ ! -x ~/.local/bin/$i ]
        echo "Making ~/.local/bin/$i executable."
        chmod +x ~/.local/bin/$i
    end
end

echo
echo "Press SUPER + q to reload xmonad."
echo
