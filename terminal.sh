#!/bin/sh
set -e

# @nav: desc
# install and configure kitty

SRC_CFG="$PWD/config/kitty.conf"
CONFIG_DIR="$HOME/.config/kitty"

sudo pacman -S --needed --noconfirm kitty

mkdir -p $CONFIG_DIR
if [ ! -d "$CONFIG_DIR/kitty-themes" ]; then
  git clone --depth 1 https://github.com/dexpota/kitty-themes.git $CONFIG_DIR/kitty-themes
fi


if [ ! -f "$CONFIG_DIR/kitty.conf" ]; then
    if [ -f "$SRC_CFG" ]; then
        cp "$SRC_CFG" "$CONFIG_DIR/kitty.conf"
    else
        echo "No config '$SRC_CFG'. Skipping..."
    fi
fi
