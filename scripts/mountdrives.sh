#!/bin/zsh

# HDD
sudo ntfsfix /dev/sda1
sudo mount /dev/sda1 /mnt/hdd

# M.2 - Currently Linux drive
# sudo ntfsfix /dev/nvme0n1p1
# sudo mount /dev/nvme0n1p1 /nvme
