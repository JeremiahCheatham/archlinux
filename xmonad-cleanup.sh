#!/bin/fish

if [ -f /usr/bin/alsamixer ]
    echo "Cool alsa-utils is already installed."
else
    echo "Installing alsa-utils."
    sudo pacman -S alsa-utils
end


if groups | grep video > /dev/null
    echo "Cool you're already in the video group."
else
    echo "Adding you to video group. A restart will be needed."
    sudo usermod -a -G video $USER
end

if [ -f /usr/bin/light ]
    echo "Cool light is already installed."
else
    echo "Installing light."
    sudo pacman -S light
end

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

if [ -f /usr/bin/firefox ]
    echo "Cool firefox is already installed."
else
    echo "Install firefox."
    sudo pacman -S firefox
end


if grep -R "qutebrowser" ~/.xmonad/xmonad.hs > /dev/null
    echo "Replace firefox with qutebrowser in xmonad.hs"
    sed -i 's/qutebrowser/firefox/' ~/.xmonad/xmonad.hs
else
    echo "Cool firefox already replaced qutebrowser in xmonad.hs"
end


if [ -f /usr/bin/pulseaudio ]
    echo "Pulse Audio found...."
    if [ -f /etc/alsa/conf.d/99-pulseaudio-default.conf ]
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
