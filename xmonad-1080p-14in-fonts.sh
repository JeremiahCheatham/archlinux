#!/bin/fish

sed -i 's/family: Source Code Pro/# family: Source Code Pro/' ~/.config/alacritty/alacritty.yml
sed -i 's/# family: Hack/family: Hack/' ~/.config/alacritty/alacritty.yml
sed -i 's/size: 12.0/size: 14.0/' ~/.config/alacritty/alacritty.yml

sed -i 's/SauceCodePro Nerd Font Mono:regular:size=9/SauceCodePro Nerd Font Mono:regular:size=14/' ~/.xmonad/xmonad.hs

sed -i 's/Ubuntu:weight=bold:pixelsize=11/Ubuntu:weight=bold:pixelsize=14/' ~/.config/xmobar/*-xmobarrc
sed -i 's/Mononoki:pixelsize=11/Mononoki:pixelsize=14/' ~/.config/xmobar/*-xmobarrc
sed -i 's/Font Awesome 5 Free Solid:pixelsize=12/Font Awesome 5 Free Solid:pixelsize=15/' ~/.config/xmobar/*-xmobarrc
sed -i 's/Font Awesome 5 Brands:pixelsize=12/Font Awesome 5 Brands:pixelsize=15/' ~/.config/xmobar/*-xmobarrc

sed -i 's/Source Code Pro:bold:size=10/Source Code Pro:bold:size=12/' ~/.config/conky/xmonad/*.conkyrc
sed -i 's/Raleway:bold:size=30/Raleway:bold:size=44/' ~/.config/conky/xmonad/*.conkyrc
sed -i 's/Ubuntu:size=14/Ubuntu:size=18/' ~/.config/conky/xmonad/*.conkyrc
sed -i 's/Raleway:bold:size=9/Raleway:bold:size=14/' ~/.config/conky/xmonad/*.conkyrc

sed -i 's/gtk-font-name=Noto Sans,  10/gtk-font-name=Noto Sans,  14/' ~/.config/gtk-*/settings.ini

sed -i 's/fixed=Hack,10/fixed=Hack,14/' ~/.config/kdeglobals
sed -i 's/font=Noto Sans,10/font=Noto Sans,14/' ~/.config/kdeglobals
sed -i 's/menuFont=Noto Sans,10/menuFont=Noto Sans,14/' ~/.config/kdeglobals
sed -i 's/smallestReadableFont=Noto Sans,8/smallestReadableFont=Noto Sans,12/' ~/.config/kdeglobals
sed -i 's/toolBarFont=Noto Sans,10/toolBarFont=Noto Sans,14/' ~/.config/kdeglobals
