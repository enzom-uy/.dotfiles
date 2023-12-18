#!/bin/zsh

wallpapers_dir="/home/enzom/Pictures/wallpapers/"
wallpapers=("$wallpapers_dir"/*)
wallpapers_n=${#wallpapers[@]}

random_index=$((RANDOM % wallpapers_n))

while [ "$random_index" -eq 0 ]; do
    random_index=$((RANDOM % wallpapers_n))
done

random_wallpaper=${wallpapers[$random_index]}

xwallpaper --focus  $random_wallpaper
wal -i $random_wallpaper -n
#xdotool key super+F5
#pywalfox update
