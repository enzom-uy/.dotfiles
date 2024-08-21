#!/bin/zsh

wallpapers_dir="/home/enzom/Pictures/cat/"
wallpapers=("$wallpapers_dir"/*)
wallpapers_n=${#wallpapers[@]}

random_index=$((RANDOM % wallpapers_n))

while [ "$random_index" -eq 0 ]; do
    random_index=$((RANDOM % wallpapers_n))
done

random_wallpaper=${wallpapers[$random_index]}

feh --bg-fill  $random_wallpaper
