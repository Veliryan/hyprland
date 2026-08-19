#!/bin/sh
set -e

CURRENT_DIR="$PWD"
CONFIG_DIR="$HOME"
DST_CFG="$CONFIG_DIR/.zshrc"

# @nav: desc
# install, set and configure zsh

if ! command -v paru >/dev/null 2>&1; then
  chmod +x paru.sh
  ./paru.sh
fi

paru -S --needed --noconfirm zsh curl

chsh -s "$(which zsh)"

if [ ! -d "$HOME/.local/share/zap" ]; then
  zsh -c 'curl -fsSL https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh | zsh'
fi

echo "alias ls='lsd'" >> "$DST_CFG"
echo "alias l='lsd -la'" >> "$DST_CFG"
echo "alias cl='reset && lsd -la'" >> "$DST_CFG"
echo "alias nv='nvim'" >> "$DST_CFG"
echo "alias ff='fastfetch'" >> "$DST_CFG"
