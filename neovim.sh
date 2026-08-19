#!/bin/sh
set -e

DST_DIR="$HOME/.config/nvim"

if ! command -v paru >/dev/null 2>&1; then
  chmod +x paru.sh
  ./paru.sh
fi

paru -S --needed --noconfirm neovim git ripgrep fd tar curl tree-sitter tree-sitter-cli gcc npm zip unzip

mkdir -p "$DST_DIR"

if [ ! -f "$DST_DIR/init.lua" ]; then
  git clone https://github.com/Veliryan/nvim "$DST_DIR"
fi 
