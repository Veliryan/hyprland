#!/bin/sh
set -e

# @nav: desc
# install and configure kitty

CURRENT_DIR="$PWD"
SRC_CFG="$PWD/config/kitty/kitty.conf"
CONFIG_DIR="$HOME/.config/kitty"

sudo pacman -S --needed --noconfirm foot kitty

mkdir -p $CONFIG_DIR
if [ ! -d "$CONFIG_DIR/kitty-themes" ]; then
  git clone --depth 1 https://github.com/dexpota/kitty-themes.git $CONFIG_DIR/kitty-themes
fi
if [ ! -d "$CONFIG_DIR/themes" ]; then
  git clone https://github.com/catppuccin/kitty "$CONFIG_DIR/themes"
fi


if [ ! -f "$CONFIG_DIR/kitty.conf" ]; then
  cp "$SRC_CFG" "$CONFIG_DIR/kitty.conf"
fi

mkdir -p "$HOME/.config/foot"
if [ ! -f "$HOME/.config/foot/foot.ini" ]; then
  cp "$CURRENT_DIR/config/foot/foot.ini" "$HOME/.config/foot/foot.ini"
fi
