#!/bin/fish

clear
echo "   --------- DTOS Helper 1.0 ---------"
echo "1  Autofix runs 5,6,7,9,10,11,12,13,14"
echo "2  Download latest DTOS Helper file."
echo "3  1080x1920 14in Fonts + Autofix Preset."
echo "4  768x1366 14in Fonts + Autofix Preset."
echo "5  Reset DTOS from /etc/dtos folder."
echo "   ------------- CONFIG --------------"
echo "10 Enable pacman ParallelDownloads."
echo "11 Check needed packages are installed."
echo "12 Create a touchpad.conf file."
echo "13 Disable NaturalScrolling not autofix."
echo "14 Enable Screen Backlight keys."
echo "15 Enable notification-daemon."
echo "16 Fix alsa with pulseaudio muting."
echo "17 Let QT & GTK use the KDE themes."
echo "18 Make firefox the default browser."
echo "19 Make .local/bin/ files executable."
echo "   -------------- FONTS --------------"
echo "20 Increase Xmobar font size."
echo "21 Decrease Xmobar font size."
echo "22 Increase Conky font size."
echo "23 Decrease Conky font size."
echo "24 Set the Systems font size."
echo "25 Set Systems fonts to Noto Sans & Hack"
echo "26 Set the Console font size."
echo "   -------------- QUIT ---------------"
echo "30 Quit"

read CHOICE
echo ""

if [ $CHOICE -eq 2 ]
    # Download this file.
    if curl -fLO https://raw.githubusercontent.com/JeremiahCheatham/archlinux/main/dtos-helper.sh > /dev/null 2>&1
        echo "Downloaded dtos-helper.sh successfully."
    else
        echo "Failed to download dtos-helper.sh."
    end
end

if [ $CHOICE -eq 3 ]
    # Preset for 1080x1920 14inch
    set NEWFONTSIZE 14
    set NEWXFONTSIZE 14
    set CFONTSIZE1 11
    set VCFONTSIZE 24
end

if [ $CHOICE -eq 4 ]
    # Preset for 768x1366 14inch
    set NEWFONTSIZE 10
    set NEWXFONTSIZE 10
    set CFONTSIZE1 8
    set VCFONTSIZE 18
end

if [ $CHOICE -eq 5 ]
    # Reset DTOS from /etc/dtos.
    echo "Resetting DTOS from /etc/dtos folder."
    /bin/cp -r /etc/dtos/.* $HOME/
end

if [ $CHOICE -eq 10 ] || [ $CHOICE -eq 1 ]
    # Check ParallelDownloads is enabled.
    if grep -R "^ParallelDownloads" /etc/pacman.conf > /dev/null
        echo "Cool ParallelDownloads is already enabled."
    else
        echo "Enabling ParallelDownloads."
        sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
    end
end

if [ $CHOICE -eq 11 ] || [ $CHOICE -eq 1 ]
    # Check these packages are installed.
    set PACKAGES alsa-utils light notification-daemon haskell-language-server bash-language-server firefox gnome-keyring ttf-hack noto-fonts terminus-font
    if pacman -Q $PACKAGES > /dev/null 2>&1
        echo "Cool needed packages are already installed."
    else
        sudo pacman -S $PACKAGES --needed
    end
end

if [ $CHOICE -eq 12 ] || [ $CHOICE -eq 1 ]
    # Add touch pad support with tapping and NaturalScrolling.
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

if [ $CHOICE -eq 13 ]
    # Disable NaturalScrolling direction.
    if [ -f /etc/X11/xorg.conf.d/30-touchpad.conf ]
        echo "Setting NaturalScrolling to false."
        sudo sed -i 's/"NaturalScrolling" "true"/"NaturalScrolling" "false"/' /etc/X11/xorg.conf.d/30-touchpad.conf
    else
        echo "TouchPad config file not found. Generate it first."
    end
end

if [ $CHOICE -eq 14 ] || [ $CHOICE -eq 1 ]
    # Make sure light is installed.
    if pacman -Q light > /dev/null 2>&1
        echo "Cool light is already installed."
    else
        echo "Installing light."
        sudo pacman -S light
    end

    # You need to be in Video group for light to change screen brightness.
    if groups | grep video > /dev/null
        echo "Cool you're already in the video group."
    else
        echo "Adding you to video group. A restart will be needed."
        sudo usermod -a -G video $USER
    end

    # Add keybindings for screen brightness.
    if grep -R "XF86MonBrightnessUp" $HOME/.xmonad/xmonad.hs > /dev/null
        echo "Cool XF86MonBrightnessUp is already in xmonad.hs."
    else
        echo "Adding XF86MonBrightnessUp to xmonad.hs"
        sed -i '/XF86AudioPlay/i\        , ("<XF86MonBrightnessUp>", spawn "light -A 5")' $HOME/.xmonad/xmonad.hs
    end

    if grep -R "XF86MonBrightnessDown" $HOME/.xmonad/xmonad.hs > /dev/null
        echo "Cool XF86MonBrightnessDown is already in xmonad.hs."
    else
        echo "Adding XF86MonBrightnessDown to xmonad.hs"
        sed -i '/XF86AudioPlay/i\        , ("<XF86MonBrightnessDown>", spawn "light -U 5")' $HOME/.xmonad/xmonad.hs
    end
end

if [ $CHOICE -eq 15 ] || [ $CHOICE -eq 1 ]
    # Make sure notification-daemon is installed.
    if pacman -Q notification-daemon > /dev/null 2>&1
        echo "Cool notification-daemon is already installed."
    else
        echo "Installing notification-daemon."
        sudo pacman -S notification-daemon
    end

    # Launch notification-daemon
    if grep -R "/usr/lib/notification-daemon-1.0/notification-daemon" $HOME/.xmonad/xmonad.hs > /dev/null
        echo "Cool notification-daemon is already in xmonad.hs."
    else
        echo "Adding notification-daemon to xmonad.hs"
        sed -i '/spawnOnce "picom"/i\    spawnOnce "/usr/lib/notification-daemon-1.0/notification-daemon"' $HOME/.xmonad/xmonad.hs
    end
end

if [ $CHOICE -eq 16 ] || [ $CHOICE -eq 1 ]
    # If pulse is installed add the alsa package so it mutes and unmutes correctly.
    if pacman -Q pulseaudio > /dev/null 2>&1
        echo "Pulse Audio found...."
        if pacman -Q pulseaudio-alsa > /dev/null 2>&1
            echo "Cool pulseaudio-alsa is already installed."
        else
            echo "Installing pulseaudio-alsa."
            sudo pacman -S pulseaudio-alsa
        end
        if grep -R "amixer -D pulse set Master toggle" $HOME/.xmonad/xmonad.hs > /dev/null
            echo "Cool amixer -D pulse set Master toggle is already in xmonad.hs"
        else
            echo "Updating amixer mute toggle with pulse in xmonad.hs"
            sed -i 's/amixer set Master toggle/amixer -D pulse set Master toggle/' $HOME/.xmonad/xmonad.hs
        end
    else
        echo "Skipping pulse audio."
    end
end

if [ $CHOICE -eq 17 ] || [ $CHOICE -eq 1 ]
    # Let KDE/QT5 and GTK apps use the KDE theme and font.
    if grep -R "XDG_CURRENT_DESKTOP=KDE" /etc/environment > /dev/null
        echo "Cool XDG_CURRENT_DESKTOP=KDE is already in /etc/environment."
    else
        echo "Adding XDG_CURRENT_DESKTOP=KDE to /etc/environment."
        sudo fish -c "echo 'XDG_CURRENT_DESKTOP=KDE' >> /etc/environment"
    end
end

if [ $CHOICE -eq 18 ] || [ $CHOICE -eq 1 ]
    # Make sure firefox is installed.
    if pacman -Q firefox > /dev/null 2>&1
        echo "Cool firefox is already installed."
    else
        echo "Installing firefox."
        sudo pacman -S firefox
    end

    # Make sure firefox is the default browser.
    if grep -R "qutebrowser" $HOME/.xmonad/xmonad.hs > /dev/null
        echo "Replacing qutebrowser with firefox in xmonad.hs"
        sed -i 's/qutebrowser/firefox/' $HOME/.xmonad/xmonad.hs
    else
        echo "Cool firefox already replaced qutebrowser in xmonad.hs"
    end
end

if [ $CHOICE -eq 19 ] || [ $CHOICE -eq 1 ] || [ $CHOICE -eq 5 ]
    # Check bin files are executable.
    echo "Checking if ~/.local/bin/ scripts are executable."
    set BINS clock dtos-colorscheme dtos-help kernel memory pacupdate upt volume
    for i in $BINS
        if [ ! -x $HOME/.local/bin/$i ]
            echo "Making ~/.local/bin/$i executable."
            chmod +x $HOME/.local/bin/$i
        end
    end
    chmod +x $HOME/.config/xmobar/trayer-padding-icon.sh
    chmod +x $HOME/.xmonad/xmonad_keys.sh
    chmod +x $HOME/.config/sxiv/exec/key-handler
    chmod +x $HOME/.config/qutebrowser/solarized-everything-css/release.sh
    chmod +x $HOME/.config/dmscripts/config
end

if [ $CHOICE -eq 20 ]
    if [ -f $HOME/.config/xmobar/doom-one-xmobarrc ]
        set OLDXFONTSIZE ( grep weight $HOME/.config/xmobar/doom-one-xmobarrc | cut -d "=" -f 4 | cut -d ":" -f 1 )
        set NEWXFONTSIZE ( echo $OLDXFONTSIZE + 1 | bc )
        set LGXFONTSIZE ( echo $OLDXFONTSIZE + 2 | bc )
        if [ $NEWXFONTSIZE -le 20 ]
            set LINENUMBERS (grep -n pixelsize= $HOME/.config/xmobar/doom-one-xmobarrc | cut -f 1 -d ":")
            sed -i "$LINENUMBERS[1] s/pixelsize=[0-9]*/pixelsize=$NEWXFONTSIZE/" $HOME/.config/xmobar/*-xmobarrc
            sed -i "$LINENUMBERS[2] s/pixelsize=[0-9]*/pixelsize=$NEWXFONTSIZE/" $HOME/.config/xmobar/*-xmobarrc
            sed -i "$LINENUMBERS[3] s/pixelsize=[0-9]*/pixelsize=$LGXFONTSIZE/" $HOME/.config/xmobar/*-xmobarrc
            sed -i "$LINENUMBERS[4] s/pixelsize=[0-9]*/pixelsize=$LGXFONTSIZE/" $HOME/.config/xmobar/*-xmobarrc
            xmonad --restart
            echo "Xmobar font increased to $NEWXFONTSIZE."
        else
            echo "Xmobar font limited to $OLDXFONTSIZE."
            echo "Font size unchanged."
        end
    else
        echo "Xmobar theme file not found."
    end
end

if [ $CHOICE -eq 21 ]
    if [ -f $HOME/.config/xmobar/doom-one-xmobarrc ]
        set OLDXFONTSIZE ( grep weight $HOME/.config/xmobar/doom-one-xmobarrc | cut -d "=" -f 4 | cut -d ":" -f 1 )
        set NEWXFONTSIZE ( echo $OLDXFONTSIZE - 1 | bc )
        if [ $NEWXFONTSIZE -ge 8 ]
            set LINENUMBERS (grep -n pixelsize= $HOME/.config/xmobar/doom-one-xmobarrc | cut -f 1 -d ":")
            sed -i "$LINENUMBERS[1] s/pixelsize=[0-9]*/pixelsize=$NEWXFONTSIZE/" $HOME/.config/xmobar/*-xmobarrc
            sed -i "$LINENUMBERS[2] s/pixelsize=[0-9]*/pixelsize=$NEWXFONTSIZE/" $HOME/.config/xmobar/*-xmobarrc
            sed -i "$LINENUMBERS[3] s/pixelsize=[0-9]*/pixelsize=$OLDXFONTSIZE/" $HOME/.config/xmobar/*-xmobarrc
            sed -i "$LINENUMBERS[4] s/pixelsize=[0-9]*/pixelsize=$OLDXFONTSIZE/" $HOME/.config/xmobar/*-xmobarrc
            xmonad --restart
            echo "Xmobar font increased to $NEWXFONTSIZE."
        else
            echo "Xmobar font limited to $OLDXFONTSIZE."
            echo "Font size unchanged."
        end
    else
        echo "Xmobar theme file not found."
    end
end

if [ $CHOICE -eq 22 ]
    if [ -f $HOME/.config/conky/xmonad/doom-one-01.conkyrc ]
        set OLDCFONTSIZE (grep size= $HOME/.config/conky/xmonad/doom-one-01.conkyrc | cut -f 3 -d "=" | cut -f 1 -d "'" | head -1)
        set CFONTSIZE1 ( echo $OLDCFONTSIZE + 1 | bc )
        if [ $CFONTSIZE1 -le 20 ]
            set LINENUMBERS ( grep -n size= $HOME/.config/conky/xmonad/doom-one-01.conkyrc | cut -f 1 -d ":" )
            set CFONTSIZE2 (printf %.0f (echo "$CFONTSIZE1 * 3.5" | bc))
            set CFONTSIZE3 (printf %.0f (echo "$CFONTSIZE1 * 1.5" | bc))
            set CFONTSIZE4 (printf %.0f (echo "$CFONTSIZE1 * 1.1" | bc))
            sed -i "$LINENUMBERS[1] s/size=[0-9]*/size=$CFONTSIZE1/" $HOME/.config/conky/xmonad/*.conkyrc
            sed -i "$LINENUMBERS[2] s/size=[0-9]*/size=$CFONTSIZE2/" $HOME/.config/conky/xmonad/*.conkyrc
            sed -i "$LINENUMBERS[3] s/size=[0-9]*/size=$CFONTSIZE3/" $HOME/.config/conky/xmonad/*.conkyrc
            sed -i "$LINENUMBERS[4] s/size=[0-9]*/size=$CFONTSIZE4/" $HOME/.config/conky/xmonad/*.conkyrc
            echo "Conky font increased to $CFONTSIZE1."
        else
            echo "Xmobar font limited to $OLDCFONTSIZE."
            echo "Font size unchanged."
        end
    else
        echo "Conky theme files not found."
    end
end

if [ $CHOICE -eq 23 ]
    if [ -f $HOME/.config/conky/xmonad/doom-one-01.conkyrc ]
        set OLDCFONTSIZE (grep size= $HOME/.config/conky/xmonad/doom-one-01.conkyrc | cut -f 3 -d "=" | cut -f 1 -d "'" | head -1)
        set CFONTSIZE1 ( echo $OLDCFONTSIZE - 1 | bc )
        if [ $CFONTSIZE1 -ge 4 ]
            set LINENUMBERS ( grep -n size= $HOME/.config/conky/xmonad/doom-one-01.conkyrc | cut -f 1 -d ":" )
            set CFONTSIZE2 (printf %.0f (echo "$CFONTSIZE1 * 3.5" | bc))
            set CFONTSIZE3 (printf %.0f (echo "$CFONTSIZE1 * 1.5" | bc))
            set CFONTSIZE4 (printf %.0f (echo "$CFONTSIZE1 * 1.1" | bc))
            sed -i "$LINENUMBERS[1] s/size=[0-9]*/size=$CFONTSIZE1/" $HOME/.config/conky/xmonad/*.conkyrc
            sed -i "$LINENUMBERS[2] s/size=[0-9]*/size=$CFONTSIZE2/" $HOME/.config/conky/xmonad/*.conkyrc
            sed -i "$LINENUMBERS[3] s/size=[0-9]*/size=$CFONTSIZE3/" $HOME/.config/conky/xmonad/*.conkyrc
            sed -i "$LINENUMBERS[4] s/size=[0-9]*/size=$CFONTSIZE4/" $HOME/.config/conky/xmonad/*.conkyrc
            echo "Conky font decreased to $CFONTSIZE1."
        else
            echo "Xmobar font limited to $OLDCFONTSIZE."
            echo "Font size unchanged."
        end
    else
        echo "Conky theme files not found."
    end
end

if [ $CHOICE -eq 3 ] || [ $CHOICE -eq 4 ]
    # Xmobar font size for presets.
    set LINENUMBERS (grep -n pixelsize= $HOME/.config/xmobar/doom-one-xmobarrc | cut -f 1 -d ":")
    set LGXFONTSIZE ( echo $NEWXFONTSIZE + 1 | bc )
    sed -i "$LINENUMBERS[1] s/pixelsize=[0-9]*/pixelsize=$NEWXFONTSIZE/" $HOME/.config/xmobar/*-xmobarrc
    sed -i "$LINENUMBERS[2] s/pixelsize=[0-9]*/pixelsize=$NEWXFONTSIZE/" $HOME/.config/xmobar/*-xmobarrc
    sed -i "$LINENUMBERS[3] s/pixelsize=[0-9]*/pixelsize=$LGXFONTSIZE/" $HOME/.config/xmobar/*-xmobarrc
    sed -i "$LINENUMBERS[4] s/pixelsize=[0-9]*/pixelsize=$LGXFONTSIZE/" $HOME/.config/xmobar/*-xmobarrc
    xmonad --restart
    echo "Setting font size $NEWXFONTSIZE for Xmobar."
end

if [ $CHOICE -eq 3 ] || [ $CHOICE -eq 4 ]
    # Conky font size for presets.
    set LINENUMBERS ( grep -n size= $HOME/.config/conky/xmonad/doom-one-01.conkyrc | cut -f 1 -d ":" )
    set CFONTSIZE2 (printf %.0f (echo "$CFONTSIZE1 * 3.5" | bc))
    set CFONTSIZE3 (printf %.0f (echo "$CFONTSIZE1 * 1.5" | bc))
    set CFONTSIZE4 (printf %.0f (echo "$CFONTSIZE1 * 1.1" | bc))
    sed -i "$LINENUMBERS[1] s/size=[0-9]*/size=$CFONTSIZE1/" $HOME/.config/conky/xmonad/*.conkyrc
    sed -i "$LINENUMBERS[2] s/size=[0-9]*/size=$CFONTSIZE2/" $HOME/.config/conky/xmonad/*.conkyrc
    sed -i "$LINENUMBERS[3] s/size=[0-9]*/size=$CFONTSIZE3/" $HOME/.config/conky/xmonad/*.conkyrc
    sed -i "$LINENUMBERS[4] s/size=[0-9]*/size=$CFONTSIZE4/" $HOME/.config/conky/xmonad/*.conkyrc
    echo "Setting font size $CFONTSIZE1 for Conky."
end

if [ $CHOICE -eq 24 ]
    set NEWFONTSIZE 0
    while [ $NEWFONTSIZE -lt 6 ] || [ $NEWFONTSIZE -gt 20 ]
        echo "Choose a font size between 6 and 20."
        read NEWFONTSIZE
        echo ""
    end

end

if [ $CHOICE -eq 24 ] || [ $CHOICE -eq 3 ] || [ $CHOICE -eq 4 ]
    # Set Systems font size.

    # Dmenu Font Size
    echo "Setting font size $NEWFONTSIZE in ~/.config/dmscripts/config"
    if grep -R "xft:size=14" $HOME/.config/dmscripts/config > /dev/null
        sed -i "s/xft:size=[0-9]*/xft:size=$NEWFONTSIZE/" $HOME/.config/dmscripts/config
    else
        sed -i "s/dmenu -i -l 20 -p/dmenu -fn xft:size=$NEWFONTSIZE -i -l 20 -p/" $HOME/.config/dmscripts/config
    end
    if grep -R "dmenu_run -fn xft:size=" $HOME/.xmonad/xmonad.hs > /dev/null
        sed -i "s/dmenu_run -fn xft:size=[0-9]*/dmenu_run -fn xft:size=$NEWFONTSIZE/" $HOME/.xmonad/xmonad.hs
    else
        sed -i "s/dmenu_run -i -p/dmenu_run -fn xft:size=$NEWFONTSIZE -i -p/" $HOME/.xmonad/xmonad.hs
    end

    # Xmonad font size.
    echo "Setting font size $NEWFONTSIZE in ~/.xmonad/xmonad.hs"
    set LINENUMBER (grep -n "myFont" $HOME/.xmonad/xmonad.hs | grep "size=" | cut -f 1 -d ":")
    sed -i "$LINENUMBER s/size=[0-9]*/size=$NEWFONTSIZE/" $HOME/.xmonad/xmonad.hs

    # Alacritty font size.
    if [ -f $HOME/.config/alacritty/alacritty.yml ]
        echo "Setting font size $NEWFONTSIZE in ~/.config/alacritty/alacritty.yml"
        sed -i "s/size: [0-9]*.0/size: $NEWFONTSIZE.0/" $HOME/.config/alacritty/alacritty.yml
    else
        echo "~/.config/alacritty/alacritty.yml file not founds, skipping."
    end

    # Set GTK 2.0 font size.
    if [ -f $HOME/.gtkrc-2.0 ]
        echo "Setting font size $NEWFONTSIZE in ~/.gtkrc-2.0."
        set LINENUMBER (grep -n "gtk-font-name=" $HOME/.gtkrc-2.0 | cut -d ":" -f 1)
        set OLDFONTSIZE (grep "gtk-font-name=" $HOME/.gtkrc-2.0 | cut -d "," -f 2 | cut -d "\"" -f 1)
        sed -i "$LINENUMBER s/$OLDFONTSIZE/  $NEWFONTSIZE/" $HOME/.gtkrc-2.0
    else
        echo "~/.gtkrc-2.0 file not founds, skipping."
    end

    # Set GTK 3.0 font size.
    if [ -f $HOME/.config/gtk-3.0/settings.ini ]
        echo "Setting font size $NEWFONTSIZE in ~/.config/gtk-3.0/settings.ini."
        set LINENUMBER (grep -n "gtk-font-name=" $HOME/.config/gtk-3.0/settings.ini | cut -d ":" -f 1)
        set OLDFONTSIZE (grep "gtk-font-name=" $HOME/.config/gtk-3.0/settings.ini | cut -d "," -f 2)
        sed -i "$LINENUMBER s/$OLDFONTSIZE/  $NEWFONTSIZE/" $HOME/.config/gtk-3.0/settings.ini
    else
        echo "~/.config/gtk-3.0/settings.ini file not founds, skipping."
    end

    # Set GTK 4.0 font size.
    if [ -f $HOME/.config/gtk-4.0/settings.ini ]
        echo "Setting font size $NEWFONTSIZE in ~/.config/gtk-4.0/settings.ini."
        set LINENUMBER (grep -n "gtk-font-name=" $HOME/.config/gtk-4.0/settings.ini | cut -d ":" -f 1)
        set OLDFONTSIZE (grep "gtk-font-name=" $HOME/.config/gtk-4.0/settings.ini | cut -d "," -f 2)
        sed -i "$LINENUMBER s/$OLDFONTSIZE/  $NEWFONTSIZE/" $HOME/.config/gtk-4.0/settings.ini
    else
        echo "~/.config/gtk-4.0/settings.ini file not founds, skipping."
    end

    # Set QT/KDE font size.
    if [ -f $HOME/.config/kdeglobals ]
        echo "Setting font size $NEWFONTSIZE in ~/.config/kdeglobals."
        set SMALLFONTSIZE (printf %.0f (echo "$NEWFONTSIZE * 0.8" | bc))
        set LINENUMBER (grep -n "fixed=" $HOME/.config/kdeglobals | cut -d ":" -f 1)
        set OLDFONTSIZE (grep "fixed=" $HOME/.config/kdeglobals | cut -d "," -f 2)
        sed -i "$LINENUMBER s/$OLDFONTSIZE/$NEWFONTSIZE/1" $HOME/.config/kdeglobals
        set LINENUMBER (grep -n "font=" $HOME/.config/kdeglobals | cut -d ":" -f 1)
        set OLDFONTSIZE (grep "font=" $HOME/.config/kdeglobals | cut -d "," -f 2)
        sed -i "$LINENUMBER s/$OLDFONTSIZE/$NEWFONTSIZE/1" $HOME/.config/kdeglobals
        set LINENUMBER (grep -n "menuFont=" $HOME/.config/kdeglobals | cut -d ":" -f 1)
        set OLDFONTSIZE (grep "menuFont=" $HOME/.config/kdeglobals | cut -d "," -f 2)
        sed -i "$LINENUMBER s/$OLDFONTSIZE/$NEWFONTSIZE/1" $HOME/.config/kdeglobals
        set LINENUMBER (grep -n "smallestReadableFont=" $HOME/.config/kdeglobals | cut -d ":" -f 1)
        set OLDFONTSIZE (grep "smallestReadableFont=" $HOME/.config/kdeglobals | cut -d "," -f 2)
        sed -i "$LINENUMBER s/$OLDFONTSIZE/$SMALLFONTSIZE/1" $HOME/.config/kdeglobals
        set LINENUMBER (grep -n "toolBarFont=" $HOME/.config/kdeglobals | cut -d ":" -f 1)
        set OLDFONTSIZE (grep "toolBarFont=" $HOME/.config/kdeglobals | cut -d "," -f 2)
        sed -i "$LINENUMBER s/$OLDFONTSIZE/$NEWFONTSIZE/1" $HOME/.config/kdeglobals
    else
        echo "~/.config/kdeglobals file not found, skipping."
    end
end

if [ $CHOICE -eq 25 ] || [ $CHOICE -eq 3 ] || [ $CHOICE -eq 4 ]
    # Setting fonts to Noto Sans and Hack.

    # Setting Alacritty fonts to Hack.
    if [ -f $HOME/.config/alacritty/alacritty.yml ]
        echo "Setting font Noto Sans in ~/.config/alacritty/alacritty.yml"
        sed -i 's/    family: Source Code Pro/    # family: Source Code Pro/' $HOME/.config/alacritty/alacritty.yml
        sed -i 's/    # family: Hack/    family: Hack/' $HOME/.config/alacritty/alacritty.yml
    else
        echo "~/.config/alacritty/alacritty.yml file not founds, skipping."
    end

    # Setting Xmobar fonts to Noto Sans.
    if [ -f $HOME/.config/xmobar/doom-one-xmobarrc ]
        echo "Setting Xmobar fonts to Noto Sans."
        sed -i 's/Ubuntu/Noto Sans/' $HOME/.config/xmobar/*-xmobarrc
    else
        echo "Xmobar theme files not found."
    end

    # Setting Conky fonts to Noto Sans.
    if [ -f $HOME/.config/conky/xmonad/doom-one-01.conkyrc ]
        echo "Setting Conky fonts to Noto Sans."
        sed -i 's/Source Code Pro/Noto Sans/' $HOME/.config/conky/xmonad/*.conkyrc
        sed -i 's/Raleway/Noto Sans/' $HOME/.config/conky/xmonad/*.conkyrc
        sed -i 's/Ubuntu/Noto Sans/' $HOME/.config/conky/xmonad/*.conkyrc
    else
        echo "Conky theme files not found."
    end

    # Setting font Noto Sans in ~/.gtkrc-2.0.
    if [ -f $HOME/.gtkrc-2.0 ]
        echo "Setting font Noto Sans in ~/.gtkrc-2.0."
        set OLDFONT (grep -R "gtk-font-name=" $HOME/.gtkrc-2.0 | cut -d '"' -f 2 | cut -d "," -f 1)
        sed -i "s/$OLDFONT/Noto Sans/" $HOME/.gtkrc-2.0
    else
        echo "~/.gtkrc-2.0 file not founds, skipping."
    end

    # Setting font Noto Sans in ~/.config/gtk-3.0/settings.ini.
    if [ -f $HOME/.config/gtk-3.0/settings.ini ]
        echo "Setting font Noto Sans in ~/.config/gtk-3.0/settings.ini."
        set OLDFONT (grep -R "gtk-font-name=" $HOME/.config/gtk-3.0/settings.ini | cut -d "=" -f 2 | cut -d "," -f 1)
        sed -i "s/$OLDFONT/Noto Sans/" $HOME/.config/gtk-3.0/settings.ini
    else
        echo "~/.config/gtk-3.0/settings.ini file not founds, skipping."
    end

    # Setting font Noto Sans in ~/.config/gtk-4.0/settings.ini.
    if [ -f $HOME/.config/gtk-4.0/settings.ini ]
        echo "Setting font Noto Sans in ~/.config/gtk-4.0/settings.ini."
        set OLDFONT (grep -R "gtk-font-name=" $HOME/.config/gtk-4.0/settings.ini | cut -d "=" -f 2 | cut -d "," -f 1)
        sed -i "s/$OLDFONT/Noto Sans/" $HOME/.config/gtk-4.0/settings.ini
    else
        echo "~/.config/gtk-4.0/settings.ini file not founds, skipping."
    end
end


if [ $CHOICE -eq 26 ]
    # Choose a Console font size.
    set VCFONTLIST ter-112 ter-114 ter-116 ter-118 ter-120 ter-122 ter-124 ter-128 ter-132
    set VCFONTSIZE 0
    while not echo $VCFONTLIST | grep "ter-1$VCFONTSIZE" > /dev/null
        echo "Enter a Console font size."
        echo "12 14 16 18 20 22 24 28 32"
        read VCFONTSIZE
        echo ""
    end
end

if [ $CHOICE -eq 26 ] || [ $CHOICE -eq 3 ] || [ $CHOICE -eq 4 ]
    # Set Console font size to VCFONTSIZE.
    echo "Setting font size $VCFONTSIZE for the console."
    if [ -f /etc/vconsole.conf ]
        if grep -R "FONT=" /etc/vconsole.conf > /dev/null
            sudo sed -i '/FONT=/d' /etc/vconsole.conf
        end
        if grep -R "FONT_MAP=" /etc/vconsole.conf > /dev/null
            sudo sed -i '/FONT_MAP=/d' /etc/vconsole.conf
        end
    end
    sudo fish -c "echo "FONT=ter-1"$VCFONTSIZE"n" >> /etc/vconsole.conf"
    sudo fish -c "echo "FONT_MAP=8859-2" >> /etc/vconsole.conf"
end

if [ $CHOICE -eq 30 ]
    # Exit script.
    exit
end

echo ""
echo "Press any key to continue."
read
fish (status filename) && exit

    set NEWXFONTSIZE 14
    set CFONTSIZE1 11
    set VCFONTSIZE 24
end

if [ $CHOICE -eq 4 ]
    # Preset for 768x1366 14inch
    set NEWFONTSIZE 10
    set NEWXFONTSIZE 10
    set CFONTSIZE1 8
    set VCFONTSIZE 18
end

if [ $CHOICE -eq 5 ]
    # Reset DTOS from /etc/dtos.
    echo "Resetting DTOS from /etc/dtos folder."
    /bin/cp -r /etc/dtos/.* $HOME/
end

if [ $CHOICE -eq 10 ] || [ $CHOICE -eq 1 ]
    # Check ParallelDownloads is enabled.
    if grep -R "^ParallelDownloads" /etc/pacman.conf > /dev/null
        echo "Cool ParallelDownloads is already enabled."
    else
        echo "Enabling ParallelDownloads."
        sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
    end
end

if [ $CHOICE -eq 11 ] || [ $CHOICE -eq 1 ]
    # Check these packages are installed.
    set PACKAGES alsa-utils light notification-daemon haskell-language-server bash-language-server firefox gnome-keyring ttf-hack noto-fonts terminus-font
    if pacman -Q $PACKAGES > /dev/null 2>&1
        echo "Cool needed packages are already installed."
    else
        sudo pacman -S $PACKAGES --needed
    end
end

if [ $CHOICE -eq 12 ] || [ $CHOICE -eq 1 ]
    # Add touch pad support with tapping and NaturalScrolling.
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

if [ $CHOICE -eq 13 ]
    # Disable NaturalScrolling direction.
    if [ -f /etc/X11/xorg.conf.d/30-touchpad.conf ]
        echo "Setting NaturalScrolling to false."
        sudo sed -i 's/"NaturalScrolling" "true"/"NaturalScrolling" "false"/' /etc/X11/xorg.conf.d/30-touchpad.conf
    else
        echo "TouchPad config file not found. Generate it first."
    end
end

if [ $CHOICE -eq 14 ] || [ $CHOICE -eq 1 ]
    # Make sure light is installed.
    if pacman -Q light > /dev/null 2>&1
        echo "Cool light is already installed."
    else
        echo "Installing light."
        sudo pacman -S light
    end

    # You need to be in Video group for light to change screen brightness.
    if groups | grep video > /dev/null
        echo "Cool you're already in the video group."
    else
        echo "Adding you to video group. A restart will be needed."
        sudo usermod -a -G video $USER
    end

    # Add keybindings for screen brightness.
    if grep -R "XF86MonBrightnessUp" $HOME/.xmonad/xmonad.hs > /dev/null
        echo "Cool XF86MonBrightnessUp is already in xmonad.hs."
    else
        echo "Adding XF86MonBrightnessUp to xmonad.hs"
        sed -i '/XF86AudioPlay/i\        , ("<XF86MonBrightnessUp>", spawn "light -A 5")' $HOME/.xmonad/xmonad.hs
    end

    if grep -R "XF86MonBrightnessDown" $HOME/.xmonad/xmonad.hs > /dev/null
        echo "Cool XF86MonBrightnessDown is already in xmonad.hs."
    else
        echo "Adding XF86MonBrightnessDown to xmonad.hs"
        sed -i '/XF86AudioPlay/i\        , ("<XF86MonBrightnessDown>", spawn "light -U 5")' $HOME/.xmonad/xmonad.hs
    end
end

if [ $CHOICE -eq 15 ] || [ $CHOICE -eq 1 ]
    # Make sure notification-daemon is installed.
    if pacman -Q notification-daemon > /dev/null 2>&1
        echo "Cool notification-daemon is already installed."
    else
        echo "Installing notification-daemon."
        sudo pacman -S notification-daemon
    end

    # Launch notification-daemon
    if grep -R "/usr/lib/notification-daemon-1.0/notification-daemon" $HOME/.xmonad/xmonad.hs > /dev/null
        echo "Cool notification-daemon is already in xmonad.hs."
    else
        echo "Adding notification-daemon to xmonad.hs"
        sed -i '/spawnOnce "picom"/i\    spawnOnce "/usr/lib/notification-daemon-1.0/notification-daemon"' $HOME/.xmonad/xmonad.hs
    end
end

if [ $CHOICE -eq 16 ] || [ $CHOICE -eq 1 ]
    # If pulse is installed add the alsa package so it mutes and unmutes correctly.
    if pacman -Q pulseaudio > /dev/null 2>&1
        echo "Pulse Audio found...."
        if pacman -Q pulseaudio-alsa > /dev/null 2>&1
            echo "Cool pulseaudio-alsa is already installed."
        else
            echo "Installing pulseaudio-alsa."
            sudo pacman -S pulseaudio-alsa
        end
        if grep -R "amixer -D pulse set Master toggle" $HOME/.xmonad/xmonad.hs > /dev/null
            echo "Cool amixer -D pulse set Master toggle is already in xmonad.hs"
        else
            echo "Updating amixer mute toggle with pulse in xmonad.hs"
            sed -i 's/amixer set Master toggle/amixer -D pulse set Master toggle/' $HOME/.xmonad/xmonad.hs
        end
    else
        echo "Skipping pulse audio."
    end
end

if [ $CHOICE -eq 17 ] || [ $CHOICE -eq 1 ]
    # Let KDE/QT5 and GTK apps use the KDE theme and font.
    if grep -R "XDG_CURRENT_DESKTOP=KDE" /etc/environment > /dev/null
        echo "Cool XDG_CURRENT_DESKTOP=KDE is already in /etc/environment."
    else
        echo "Adding XDG_CURRENT_DESKTOP=KDE to /etc/environment."
        sudo fish -c "echo 'XDG_CURRENT_DESKTOP=KDE' >> /etc/environment"
    end
end

if [ $CHOICE -eq 18 ] || [ $CHOICE -eq 1 ]
    # Make sure firefox is installed.
    if pacman -Q firefox > /dev/null 2>&1
        echo "Cool firefox is already installed."
    else
        echo "Installing firefox."
        sudo pacman -S firefox
    end

    # Make sure firefox is the default browser.
    if grep -R "qutebrowser" $HOME/.xmonad/xmonad.hs > /dev/null
        echo "Replacing qutebrowser with firefox in xmonad.hs"
        sed -i 's/qutebrowser/firefox/' $HOME/.xmonad/xmonad.hs
    else
        echo "Cool firefox already replaced qutebrowser in xmonad.hs"
    end
end

if [ $CHOICE -eq 19 ] || [ $CHOICE -eq 1 ] || [ $CHOICE -eq 5 ]
    # Check bin files are executable.
    echo "Checking if ~/.local/bin/ scripts are executable."
    set BINS clock dtos-colorscheme dtos-help kernel memory pacupdate upt volume
    for i in $BINS
        if [ ! -x $HOME/.local/bin/$i ]
            echo "Making ~/.local/bin/$i executable."
            chmod +x $HOME/.local/bin/$i
        end
    end
    chmod +x $HOME/.config/xmobar/trayer-padding-icon.sh
    chmod +x $HOME/.xmonad/xmonad_keys.sh
    chmod +x $HOME/.config/sxiv/exec/key-handler
    chmod +x $HOME/.config/qutebrowser/solarized-everything-css/release.sh
    chmod +x $HOME/.config/dmscripts/config
end

if [ $CHOICE -eq 20 ]
    if [ -f $HOME/.config/xmobar/doom-one-xmobarrc ]
        set OLDXFONTSIZE ( grep weight $HOME/.config/xmobar/doom-one-xmobarrc | cut -d "=" -f 4 | cut -d ":" -f 1 )
        set NEWXFONTSIZE ( echo $OLDXFONTSIZE + 1 | bc )
        set LGXFONTSIZE ( echo $OLDXFONTSIZE + 2 | bc )
        if [ $NEWXFONTSIZE -le 20 ]
            set LINENUMBERS (grep -n pixelsize= $HOME/.config/xmobar/doom-one-xmobarrc | cut -f 1 -d ":")
            sed -i "$LINENUMBERS[1] s/pixelsize=[0-9]*/pixelsize=$NEWXFONTSIZE/" $HOME/.config/xmobar/*-xmobarrc
            sed -i "$LINENUMBERS[2] s/pixelsize=[0-9]*/pixelsize=$NEWXFONTSIZE/" $HOME/.config/xmobar/*-xmobarrc
            sed -i "$LINENUMBERS[3] s/pixelsize=[0-9]*/pixelsize=$LGXFONTSIZE/" $HOME/.config/xmobar/*-xmobarrc
            sed -i "$LINENUMBERS[4] s/pixelsize=[0-9]*/pixelsize=$LGXFONTSIZE/" $HOME/.config/xmobar/*-xmobarrc
            xmonad --restart
            echo "Xmobar font increased to $NEWXFONTSIZE."
        else
            echo "Xmobar font limited to $OLDXFONTSIZE."
            echo "Font size unchanged."
        end
    else
        echo "Xmobar theme file not found."
    end
end

if [ $CHOICE -eq 21 ]
    if [ -f $HOME/.config/xmobar/doom-one-xmobarrc ]
        set OLDXFONTSIZE ( grep weight $HOME/.config/xmobar/doom-one-xmobarrc | cut -d "=" -f 4 | cut -d ":" -f 1 )
        set NEWXFONTSIZE ( echo $OLDXFONTSIZE - 1 | bc )
        if [ $NEWXFONTSIZE -ge 8 ]
            set LINENUMBERS (grep -n pixelsize= $HOME/.config/xmobar/doom-one-xmobarrc | cut -f 1 -d ":")
            sed -i "$LINENUMBERS[1] s/pixelsize=[0-9]*/pixelsize=$NEWXFONTSIZE/" $HOME/.config/xmobar/*-xmobarrc
            sed -i "$LINENUMBERS[2] s/pixelsize=[0-9]*/pixelsize=$NEWXFONTSIZE/" $HOME/.config/xmobar/*-xmobarrc
            sed -i "$LINENUMBERS[3] s/pixelsize=[0-9]*/pixelsize=$OLDXFONTSIZE/" $HOME/.config/xmobar/*-xmobarrc
            sed -i "$LINENUMBERS[4] s/pixelsize=[0-9]*/pixelsize=$OLDXFONTSIZE/" $HOME/.config/xmobar/*-xmobarrc
            xmonad --restart
            echo "Xmobar font increased to $NEWXFONTSIZE."
        else
            echo "Xmobar font limited to $OLDXFONTSIZE."
            echo "Font size unchanged."
        end
    else
        echo "Xmobar theme file not found."
    end
end

if [ $CHOICE -eq 22 ]
    if [ -f $HOME/.config/conky/xmonad/doom-one-01.conkyrc ]
        set OLDCFONTSIZE (grep size= $HOME/.config/conky/xmonad/doom-one-01.conkyrc | cut -f 3 -d "=" | cut -f 1 -d "'" | head -1)
        set CFONTSIZE1 ( echo $OLDCFONTSIZE + 1 | bc )
        if [ $CFONTSIZE1 -le 20 ]
            set LINENUMBERS ( grep -n size= $HOME/.config/conky/xmonad/doom-one-01.conkyrc | cut -f 1 -d ":" )
            set CFONTSIZE2 (printf %.0f (echo "$CFONTSIZE1 * 3.5" | bc))
            set CFONTSIZE3 (printf %.0f (echo "$CFONTSIZE1 * 1.5" | bc))
            set CFONTSIZE4 (printf %.0f (echo "$CFONTSIZE1 * 1.1" | bc))
            sed -i "$LINENUMBERS[1] s/size=[0-9]*/size=$CFONTSIZE1/" $HOME/.config/conky/xmonad/*.conkyrc
            sed -i "$LINENUMBERS[2] s/size=[0-9]*/size=$CFONTSIZE2/" $HOME/.config/conky/xmonad/*.conkyrc
            sed -i "$LINENUMBERS[3] s/size=[0-9]*/size=$CFONTSIZE3/" $HOME/.config/conky/xmonad/*.conkyrc
            sed -i "$LINENUMBERS[4] s/size=[0-9]*/size=$CFONTSIZE4/" $HOME/.config/conky/xmonad/*.conkyrc
            echo "Conky font increased to $CFONTSIZE1."
        else
            echo "Xmobar font limited to $OLDCFONTSIZE."
            echo "Font size unchanged."
        end
    else
        echo "Conky theme files not found."
    end
end

if [ $CHOICE -eq 23 ]
    if [ -f $HOME/.config/conky/xmonad/doom-one-01.conkyrc ]
        set OLDCFONTSIZE (grep size= $HOME/.config/conky/xmonad/doom-one-01.conkyrc | cut -f 3 -d "=" | cut -f 1 -d "'" | head -1)
        set CFONTSIZE1 ( echo $OLDCFONTSIZE - 1 | bc )
        if [ $CFONTSIZE1 -ge 4 ]
            set LINENUMBERS ( grep -n size= $HOME/.config/conky/xmonad/doom-one-01.conkyrc | cut -f 1 -d ":" )
            set CFONTSIZE2 (printf %.0f (echo "$CFONTSIZE1 * 3.5" | bc))
            set CFONTSIZE3 (printf %.0f (echo "$CFONTSIZE1 * 1.5" | bc))
            set CFONTSIZE4 (printf %.0f (echo "$CFONTSIZE1 * 1.1" | bc))
            sed -i "$LINENUMBERS[1] s/size=[0-9]*/size=$CFONTSIZE1/" $HOME/.config/conky/xmonad/*.conkyrc
            sed -i "$LINENUMBERS[2] s/size=[0-9]*/size=$CFONTSIZE2/" $HOME/.config/conky/xmonad/*.conkyrc
            sed -i "$LINENUMBERS[3] s/size=[0-9]*/size=$CFONTSIZE3/" $HOME/.config/conky/xmonad/*.conkyrc
            sed -i "$LINENUMBERS[4] s/size=[0-9]*/size=$CFONTSIZE4/" $HOME/.config/conky/xmonad/*.conkyrc
            echo "Conky font decreased to $CFONTSIZE1."
        else
            echo "Xmobar font limited to $OLDCFONTSIZE."
            echo "Font size unchanged."
        end
    else
        echo "Conky theme files not found."
    end
end

if [ $CHOICE -eq 3 ] || [ $CHOICE -eq 4 ]
    # Xmobar font size for presets.
    set LINENUMBERS (grep -n pixelsize= $HOME/.config/xmobar/doom-one-xmobarrc | cut -f 1 -d ":")
    set LGXFONTSIZE ( echo $NEWXFONTSIZE + 1 | bc )
    sed -i "$LINENUMBERS[1] s/pixelsize=[0-9]*/pixelsize=$NEWXFONTSIZE/" $HOME/.config/xmobar/*-xmobarrc
    sed -i "$LINENUMBERS[2] s/pixelsize=[0-9]*/pixelsize=$NEWXFONTSIZE/" $HOME/.config/xmobar/*-xmobarrc
    sed -i "$LINENUMBERS[3] s/pixelsize=[0-9]*/pixelsize=$LGXFONTSIZE/" $HOME/.config/xmobar/*-xmobarrc
    sed -i "$LINENUMBERS[4] s/pixelsize=[0-9]*/pixelsize=$LGXFONTSIZE/" $HOME/.config/xmobar/*-xmobarrc
    xmonad --restart
    echo "Setting font size $NEWXFONTSIZE for Xmobar."
end

if [ $CHOICE -eq 3 ] || [ $CHOICE -eq 4 ]
    # Conky font size for presets.
    set LINENUMBERS ( grep -n size= $HOME/.config/conky/xmonad/doom-one-01.conkyrc | cut -f 1 -d ":" )
    set CFONTSIZE2 (printf %.0f (echo "$CFONTSIZE1 * 3.5" | bc))
    set CFONTSIZE3 (printf %.0f (echo "$CFONTSIZE1 * 1.5" | bc))
    set CFONTSIZE4 (printf %.0f (echo "$CFONTSIZE1 * 1.1" | bc))
    sed -i "$LINENUMBERS[1] s/size=[0-9]*/size=$CFONTSIZE1/" $HOME/.config/conky/xmonad/*.conkyrc
    sed -i "$LINENUMBERS[2] s/size=[0-9]*/size=$CFONTSIZE2/" $HOME/.config/conky/xmonad/*.conkyrc
    sed -i "$LINENUMBERS[3] s/size=[0-9]*/size=$CFONTSIZE3/" $HOME/.config/conky/xmonad/*.conkyrc
    sed -i "$LINENUMBERS[4] s/size=[0-9]*/size=$CFONTSIZE4/" $HOME/.config/conky/xmonad/*.conkyrc
    echo "Setting font size $CFONTSIZE1 for Conky."
end

if [ $CHOICE -eq 24 ]
    set NEWFONTSIZE 0
    while [ $NEWFONTSIZE -lt 6 ] || [ $NEWFONTSIZE -gt 20 ]
        echo "Choose a font size between 6 and 20."
        read NEWFONTSIZE
    end

end

if [ $CHOICE -eq 24 ] || [ $CHOICE -eq 3 ] || [ $CHOICE -eq 4 ]
    # Set Systems font size.

    # Dmenu Font Size
    echo "Setting font size $NEWFONTSIZE in ~/.config/dmscripts/config"
    if grep -R "xft:size=14" $HOME/.config/dmscripts/config > /dev/null
        sed -i "s/xft:size=[0-9]*/xft:size=$NEWFONTSIZE/" $HOME/.config/dmscripts/config
    else
        sed -i "s/dmenu -i -l 20 -p/dmenu -fn xft:size=$NEWFONTSIZE -i -l 20 -p/" $HOME/.config/dmscripts/config
    end
    if grep -R "dmenu_run -fn xft:size=" $HOME/.xmonad/xmonad.hs > /dev/null
        sed -i "s/dmenu_run -fn xft:size=[0-9]*/dmenu_run -fn xft:size=$NEWFONTSIZE/" $HOME/.xmonad/xmonad.hs
    else
        sed -i "s/dmenu_run -i -p/dmenu_run -fn xft:size=$NEWFONTSIZE -i -p/" $HOME/.xmonad/xmonad.hs
    end

    # Xmonad font size.
    echo "Setting font size $NEWFONTSIZE in ~/.xmonad/xmonad.hs"
    set LINENUMBER (grep -n "myFont" $HOME/.xmonad/xmonad.hs | grep "size=" | cut -f 1 -d ":")
    sed -i "$LINENUMBER s/size=[0-9]*/size=$NEWFONTSIZE/" $HOME/.xmonad/xmonad.hs

    # Alacritty font size.
    if [ -f $HOME/.config/alacritty/alacritty.yml ]
        echo "Setting font size $NEWFONTSIZE in ~/.config/alacritty/alacritty.yml"
        sed -i "s/size: [0-9]*.0/size: $NEWFONTSIZE.0/" $HOME/.config/alacritty/alacritty.yml
    else
        echo "~/.config/alacritty/alacritty.yml file not founds, skipping."
    end

    # Set GTK 2.0 font size.
    if [ -f $HOME/.gtkrc-2.0 ]
        echo "Setting font size $NEWFONTSIZE in ~/.gtkrc-2.0."
        set LINENUMBER (grep -n "gtk-font-name=" $HOME/.gtkrc-2.0 | cut -d ":" -f 1)
        set OLDFONTSIZE (grep "gtk-font-name=" $HOME/.gtkrc-2.0 | cut -d "," -f 2 | cut -d "\"" -f 1)
        sed -i "$LINENUMBER s/$OLDFONTSIZE/  $NEWFONTSIZE/" $HOME/.gtkrc-2.0
    else
        echo "~/.gtkrc-2.0 file not founds, skipping."
    end

    # Set GTK 3.0 font size.
    if [ -f $HOME/.config/gtk-3.0/settings.ini ]
        echo "Setting font size $NEWFONTSIZE in ~/.config/gtk-3.0/settings.ini."
        set LINENUMBER (grep -n "gtk-font-name=" $HOME/.config/gtk-3.0/settings.ini | cut -d ":" -f 1)
        set OLDFONTSIZE (grep "gtk-font-name=" $HOME/.config/gtk-3.0/settings.ini | cut -d "," -f 2)
        sed -i "$LINENUMBER s/$OLDFONTSIZE/  $NEWFONTSIZE/" $HOME/.config/gtk-3.0/settings.ini
    else
        echo "~/.config/gtk-3.0/settings.ini file not founds, skipping."
    end

    # Set GTK 4.0 font size.
    if [ -f $HOME/.config/gtk-4.0/settings.ini ]
        echo "Setting font size $NEWFONTSIZE in ~/.config/gtk-4.0/settings.ini."
        set LINENUMBER (grep -n "gtk-font-name=" $HOME/.config/gtk-4.0/settings.ini | cut -d ":" -f 1)
        set OLDFONTSIZE (grep "gtk-font-name=" $HOME/.config/gtk-4.0/settings.ini | cut -d "," -f 2)
        sed -i "$LINENUMBER s/$OLDFONTSIZE/  $NEWFONTSIZE/" $HOME/.config/gtk-4.0/settings.ini
    else
        echo "~/.config/gtk-4.0/settings.ini file not founds, skipping."
    end

    # Set QT/KDE font size.
    if [ -f $HOME/.config/kdeglobals ]
        echo "Setting font size $NEWFONTSIZE in ~/.config/kdeglobals."
        set SMALLFONTSIZE (printf %.0f (echo "$NEWFONTSIZE * 0.8" | bc))
        set LINENUMBER (grep -n "fixed=" $HOME/.config/kdeglobals | cut -d ":" -f 1)
        set OLDFONTSIZE (grep "fixed=" $HOME/.config/kdeglobals | cut -d "," -f 2)
        sed -i "$LINENUMBER s/$OLDFONTSIZE/$NEWFONTSIZE/1" $HOME/.config/kdeglobals
        set LINENUMBER (grep -n "font=" $HOME/.config/kdeglobals | cut -d ":" -f 1)
        set OLDFONTSIZE (grep "font=" $HOME/.config/kdeglobals | cut -d "," -f 2)
        sed -i "$LINENUMBER s/$OLDFONTSIZE/$NEWFONTSIZE/1" $HOME/.config/kdeglobals
        set LINENUMBER (grep -n "menuFont=" $HOME/.config/kdeglobals | cut -d ":" -f 1)
        set OLDFONTSIZE (grep "menuFont=" $HOME/.config/kdeglobals | cut -d "," -f 2)
        sed -i "$LINENUMBER s/$OLDFONTSIZE/$NEWFONTSIZE/1" $HOME/.config/kdeglobals
        set LINENUMBER (grep -n "smallestReadableFont=" $HOME/.config/kdeglobals | cut -d ":" -f 1)
        set OLDFONTSIZE (grep "smallestReadableFont=" $HOME/.config/kdeglobals | cut -d "," -f 2)
        sed -i "$LINENUMBER s/$OLDFONTSIZE/$SMALLFONTSIZE/1" $HOME/.config/kdeglobals
        set LINENUMBER (grep -n "toolBarFont=" $HOME/.config/kdeglobals | cut -d ":" -f 1)
        set OLDFONTSIZE (grep "toolBarFont=" $HOME/.config/kdeglobals | cut -d "," -f 2)
        sed -i "$LINENUMBER s/$OLDFONTSIZE/$NEWFONTSIZE/1" $HOME/.config/kdeglobals
    else
        echo "~/.config/kdeglobals file not found, skipping."
    end
end

if [ $CHOICE -eq 25 ] || [ $CHOICE -eq 3 ] || [ $CHOICE -eq 4 ]
    # Setting fonts to Noto Sans and Hack.

    # Setting Alacritty fonts to Hack.
    if [ -f $HOME/.config/alacritty/alacritty.yml ]
        echo "Setting font Noto Sans in ~/.config/alacritty/alacritty.yml"
        sed -i 's/    family: Source Code Pro/    # family: Source Code Pro/' $HOME/.config/alacritty/alacritty.yml
        sed -i 's/    # family: Hack/    family: Hack/' $HOME/.config/alacritty/alacritty.yml
    else
        echo "~/.config/alacritty/alacritty.yml file not founds, skipping."
    end

    # Setting Xmobar fonts to Noto Sans.
    if [ -f $HOME/.config/xmobar/doom-one-xmobarrc ]
        echo "Setting Xmobar fonts to Noto Sans."
        sed -i 's/Ubuntu/Noto Sans/' $HOME/.config/xmobar/*-xmobarrc
    else
        echo "Xmobar theme files not found."
    end

    # Setting Conky fonts to Noto Sans.
    if [ -f $HOME/.config/conky/xmonad/doom-one-01.conkyrc ]
        echo "Setting Conky fonts to Noto Sans."
        sed -i 's/Source Code Pro/Noto Sans/' $HOME/.config/conky/xmonad/*.conkyrc
        sed -i 's/Raleway/Noto Sans/' $HOME/.config/conky/xmonad/*.conkyrc
        sed -i 's/Ubuntu/Noto Sans/' $HOME/.config/conky/xmonad/*.conkyrc
    else
        echo "Conky theme files not found."
    end

    # Setting font Noto Sans in ~/.gtkrc-2.0.
    if [ -f $HOME/.gtkrc-2.0 ]
        echo "Setting font Noto Sans in ~/.gtkrc-2.0."
        set OLDFONT (grep -R "gtk-font-name=" $HOME/.gtkrc-2.0 | cut -d '"' -f 2 | cut -d "," -f 1)
        sed -i "s/$OLDFONT/Noto Sans/" $HOME/.gtkrc-2.0
    else
        echo "~/.gtkrc-2.0 file not founds, skipping."
    end

    # Setting font Noto Sans in ~/.config/gtk-3.0/settings.ini.
    if [ -f $HOME/.config/gtk-3.0/settings.ini ]
        echo "Setting font Noto Sans in ~/.config/gtk-3.0/settings.ini."
        set OLDFONT (grep -R "gtk-font-name=" $HOME/.config/gtk-3.0/settings.ini | cut -d "=" -f 2 | cut -d "," -f 1)
        sed -i "s/$OLDFONT/Noto Sans/" $HOME/.config/gtk-3.0/settings.ini
    else
        echo "~/.config/gtk-3.0/settings.ini file not founds, skipping."
    end

    # Setting font Noto Sans in ~/.config/gtk-4.0/settings.ini.
    if [ -f $HOME/.config/gtk-4.0/settings.ini ]
        echo "Setting font Noto Sans in ~/.config/gtk-4.0/settings.ini."
        set OLDFONT (grep -R "gtk-font-name=" $HOME/.config/gtk-4.0/settings.ini | cut -d "=" -f 2 | cut -d "," -f 1)
        sed -i "s/$OLDFONT/Noto Sans/" $HOME/.config/gtk-4.0/settings.ini
    else
        echo "~/.config/gtk-4.0/settings.ini file not founds, skipping."
    end
end


if [ $CHOICE -eq 26 ]
    # Choose a Console font size.
    set VCFONTLIST ter-112 ter-114 ter-116 ter-118 ter-120 ter-122 ter-124 ter-128 ter-132
    set VCFONTSIZE 0
    while not echo $VCFONTLIST | grep "ter-1$VCFONTSIZE"
        echo "Enter a Console font size."
        echo "12 14 16 18 20 22 24 28 32"
        read VCFONTSIZE
    end
end

if [ $CHOICE -eq 26 ] || [ $CHOICE -eq 3 ] || [ $CHOICE -eq 4 ]
    # Set Console font size to VCFONTSIZE.
    echo "Setting font size $VCFONTSIZE for the console."
    if [ -f /etc/vconsole.conf ]
        if grep -R "FONT=" /etc/vconsole.conf > /dev/null
            sudo sed -i '/FONT=/d' /etc/vconsole.conf
        end
        if grep -R "FONT_MAP=" /etc/vconsole.conf > /dev/null
            sudo sed -i '/FONT_MAP=/d' /etc/vconsole.conf
        end
    end
    sudo fish -c "echo "FONT=ter-1"$VCFONTSIZE"n" >> /etc/vconsole.conf"
    sudo fish -c "echo "FONT_MAP=8859-2" >> /etc/vconsole.conf"
end

if [ $CHOICE -eq 30 ]
    # Exit script.
    exit
end

echo ""
echo "Press any key to continue."
read
fish (status filename) && exit
