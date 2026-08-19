#!/bin/sh
set -e

CURRENT_DIR="$PWD"
SRC_DIR="$CURRENT_DIR/config" 
DST_DIR="$HOME"

if ! command -v paru >/dev/null 2>&1; then
  chmod +x paru.sh
  ./paru.sh
fi

paru -S --needed --noconfirm tmux

if [ ! -f "$DST_DIR/.tmux.conf" ]; then
  cp "$SRC_DIR/.tmux.conf" "$DST_DIR/.tmux.conf"
fi
