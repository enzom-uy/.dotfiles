#!/bin/zsh

# Usa fzf para seleccionar la carpeta
selected_path=$(find /home/enzom/.config -maxdepth 1 -type d | fzf)

# Verifica si se seleccionó algo
if [ -n "$selected_path" ]; then
    # Mueve el directorio actual a la carpeta seleccionada
    eval "cd '$selected_path'"
fi
