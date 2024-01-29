#!/bin/zsh

wallpaper=$(ls ~/Pictures/wallpapers | dmenu -i -l 50)

[ $wallpaper -z ] || feh --bg-fill /home/enzom/Pictures/wallpapers/$wallpaper
