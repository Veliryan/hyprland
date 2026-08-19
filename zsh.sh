#!/bin/sh
set -e

CURRENT_DIR="$PWD"
CONFIG_DIR="$HOME"
DST_CFG="$CONFIG_DIR/.zshrc"

# @nav: desc
# install, set and configure zsh

sudo pacman -S --needed --noconfirm zsh curl lsd fastfetch rust


if [ ! "$SHELL" = "/usr/bin/zsh" ]; then
  chsh -s "$(which zsh)"
fi

if [ ! -d "$HOME/.local/share/zap" ]; then
  zsh -c 'curl -fsSL https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh | zsh'
fi



mkdir -p "$HOME/.config/fastfetch"
if [ ! -f "$HOME/.config/fastfetch/pokemon.sh" ]; then
  curl -o "$HOME/.config/fastfetch/pokemon.sh" "https://raw.githubusercontent.com/Discomanfulanito/pokefetch/refs/heads/main/pokemon.sh"
  chmod +x "$HOME/.config/fastfetch/pokemon.sh"
fi

echo "" >> "$DST_CFG"
echo "alias ls='lsd'" >> "$DST_CFG"
echo "alias l='lsd -la'" >> "$DST_CFG"
echo "alias cl='reset && lsd -la'" >> "$DST_CFG"
echo "alias nv='nvim'" >> "$DST_CFG"
echo "alias ff='$HOME/.config/fastfetch/pokemon.sh'" >> "$DST_CFG"
echo "export PATH='$PATH:$HOME/.cargo/bin'"

echo 'if command -v tmux >/dev/null 2>&1 && [ -z "$TMUX" ]; then' >> ~/.zshrc
echo '  tmux' >> ~/.zshrc
echo 'fi' >> ~/.zshrc
