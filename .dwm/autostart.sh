#!/bin/sh

pipewire-pulse &
xset r rate 200 30 &
nm-applet &
flameshot &

# Compositor
picom &
