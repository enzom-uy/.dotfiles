#!/usr/bin/env zsh

WALLPAPER_DIR="$HOME/Pictures/wallpapers/"

# Asegurar que swww está inicializado
pgrep -x swww-daemon >/dev/null || swww init

# Obtener lista de wallpapers y mostrar solo los nombres en rofi
SELECTED=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | 
           sed "s|$WALLPAPER_DIR||" | 
           sort | 
           rofi -dmenu -i -p "Seleccionar wallpaper")

# Si se seleccionó algo, aplicar el wallpaper
if [[ -n "$SELECTED" ]]; then
  WALLPAPER="$WALLPAPER_DIR$SELECTED"
  
  if [[ -f "$WALLPAPER" ]]; then
    swww img "$WALLPAPER" --resize crop --transition-type fade --transition-duration 1
    echo "Wallpaper aplicado: $WALLPAPER"
  else
    echo "Error: El archivo no existe"
    exit 1
  fi
else
  echo "No se seleccionó ningún wallpaper"
  exit 0
fi
