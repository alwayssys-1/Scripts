#!/bin/bash
CARPETA=${1:-.}
FICHERO_DIRS="directorios.txt"
FICHERO_EXTS="extensiones.txt"

> "$FICHERO_DIRS"
> "$FICHERO_EXTS"

# --- PARTE 1: Directorios numerados ---
contador=0
function listar_dirs() {
  local dir_actual="$1"
  local prefijo="$2"
  local i=0
  for d in "$dir_actual"/*/; do
    [ -d "$d" ] || continue
    i=$((i+1))
    if [ -z "$prefijo" ]; then num="$i"; else num="$prefijo.$i"; fi
    nombre=$(basename "$d")
    echo "$num, $nombre," >> "$FICHERO_DIRS"
    listar_dirs "$d" "$num"
  done
}

listar_dirs "$CARPETA" ""

# --- PARTE 2: Extensiones en otro fichero ---
find "$CARPETA" -type f -name "*.*" | rev | cut -d'.' -f1 | rev | sort -u | sed 's/^/./;s/$/,/' > "$FICHERO_EXTS"

echo "Directorios -> $FICHERO_DIRS"
cat "$FICHERO_DIRS"
echo ""
echo "Extensiones -> $FICHERO_EXTS"
cat "$FICHERO_EXTS"
