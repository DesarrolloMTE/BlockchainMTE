#!/bin/bash

# Desinstalar Go
if command -v go &> /dev/null; then
    echo "Desinstalando Go..."
    sudo rm -rf $(which go) /usr/local/go
else
    echo "Go no está instalado."
fi

# Eliminar configuraciones en archivos de perfil
echo "Eliminando configuraciones en archivos de perfil..."
profile_files=("$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.bash_profile" "$HOME/.profile")
for file in "${profile_files[@]}"; do
    if [ -f "$file" ]; then
        sed -i '/export PATH.*\/go\/bin/d' "$file"
    fi
done

# Eliminar directorios de trabajo específicos de Go (si existen)
echo "Eliminando directorios de trabajo de Go..."
rm -rf "$HOME/go"

echo "Go ha sido desinstalado y las configuraciones han sido eliminadas."
