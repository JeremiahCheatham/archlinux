#!/bin/fish

sed -i 's/family: Source Code Pro/# family: Source Code Pro/' ~/.config/alacritty/alacritty.yml
sed -i 's/# family: Hack/family: Hack/' ~/.config/alacritty/alacritty.yml
sed -i 's/size: 12.0/size: 10.0/' ~/.config/alacritty/alacritty.yml

sed -i 's/Ubuntu:weight=bold:pixelsize=11/Ubuntu:weight=bold:pixelsize=10/' ~/.config/xmobar/*-xmobarrc
sed -i 's/Mononoki:pixelsize=11/Mononoki:pixelsize=10/' ~/.config/xmobar/*-xmobarrc
sed -i 's/Font Awesome 5 Free Solid:pixelsize=12/Font Awesome 5 Free Solid:pixelsize=14/' ~/.config/xmobar/*-xmobarrc
sed -i 's/Font Awesome 5 Brands:pixelsize=12/Font Awesome 5 Brands:pixelsize=14/' ~/.config/xmobar/*-xmobarrc

sed -i 's/Source Code Pro:bold:size=10/Source Code Pro:bold:size=8/' ~/.config/conky/xmonad/*.conkyrc
sed -i 's/Raleway:bold:size=30/Raleway:bold:size=34/' ~/.config/conky/xmonad/*.conkyrc
# sed -i 's/Ubuntu:size=14/Ubuntu:size=14/' ~/.config/conky/xmonad/*.conkyrc
sed -i 's/Raleway:bold:size=9/Raleway:bold:size=10/' ~/.config/conky/xmonad/*.conkyrc
