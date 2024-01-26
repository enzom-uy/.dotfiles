#!/bin/sh

# Audio
pipewire &
pipewire-pulse &
xset r rate 200 30 &
./.config/scripts/randombg.sh &
./.config/scripts/mountdrives.sh &
dwmstatus &
nm-applet &
flameshot &

# Compositor
picom &
