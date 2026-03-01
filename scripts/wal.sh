#!/usr/bin/env zsh

WALLPAPER_DIR="$HOME/Pictures/wallpapers/"

# Asegurar que swww está inicializado
pgrep -x swww-daemon >/dev/null || swww init

# Obtener el wallpaper actual
CURRENT_WALL=$(swww query | awk '{print $NF}')

# Obtener un wallpaper random que no sea el actual
WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

# Aplicar el wallpaper seleccionado (sin transición, resize fill para encajar)
if [[ -n "$WALLPAPER" ]]; then
  swww img "$WALLPAPER" --resize fit --transition-type none
else
  echo "No se encontró un wallpaper válido en $WALLPAPER_DIR"
fi
