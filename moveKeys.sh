#!/bin/bash

# Ruta a los directorios
KEYS_DIR="./networkFiles/keys"
NODO_BASE="Node"

# Contador para los nodos (empezando en 1 → Node-1)
i=1

# Ordenar las carpetas de direcciones y recorrer una por una
for address_dir in $(ls "$KEYS_DIR" | sort); do
  src="$KEYS_DIR/$address_dir"
  dest="$NODO_BASE-$i/data"

  if [[ -d "$src" && -d "$dest" ]]; then
    echo "🟢 Moviendo claves de $address_dir → $dest"
    cp "$src/key" "$dest/"
    cp "$src/key.pub" "$dest/"
  else
    echo "⚠️  Directorio faltante: $src o $dest"
  fi

  i=$((i + 1))
done
