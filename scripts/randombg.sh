#!/bin/zsh

wallpapers_dir="/home/enzom/Pictures/wallpapers/"
wallpapers=("$wallpapers_dir"/*)
wallpapers_n=${#wallpapers[@]}

# Asegurarse de que random_index no sea 0 desde el principio
random_index=$((RANDOM % wallpapers_n + 1))

random_wallpaper=${wallpapers[$random_index]}

xwallpaper --focus  $random_wallpaper
wal -i $random_wallpaper -n
cat ~/.cache/wal/sequences &  
xdotool key super+F5
pywalfox update
