#!/bin/sh
set -e

DST_DIR="$HOME/.config/nvim"

sudo pacman -S --needed --noconfirm neovim git ripgrep fd tar curl tree-sitter-cli gcc npm zip unzip

mkdir -p "$DST_DIR"

if [ ! -f "$DST_DIR/init.lua" ]; then
  git clone https://github.com/Veliryan/nvim "$DST_DIR"
fi 
