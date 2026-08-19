#!/bin/sh
set -e

CURRENT_DIR="$PWD"
SRC_DIR="$CURRENT_DIR/config" 
DST_DIR="$HOME"

sudo pacman -S --needed --noconfirm tmux xclip

if [ ! -f "$DST_DIR/.tmux.conf" ]; then
  cp "$SRC_DIR/.tmux.conf" "$DST_DIR/.tmux.conf"
fi
