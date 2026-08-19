#!/bin/sh
set -e

CURRENT_DIR="$PWD"
CONFIG_DIR="$HOME/.config"
SRC_DIR="$CURRENT_DIR/config"

DST_HYPR="$CONFIG_DIR/hypr"
SRC_HYPR="$SRC_DIR/hyprland"
DST_WBAR="$CONFIG_DIR/waybar"
SRC_WBAR="$SRC_DIR/waybar"
DST_ROFI="$CONFIG_DIR/rofi"
SRC_ROFI="$SRC_DIR/rofi"

mkdir -p "$HOME/Pictures/Wallpapers"

if ! command -v paru >/dev/null 2>&1; then
  chmod +x paru.sh
  ./paru.sh
fi

paru -S --needed --noconfirm hyprland hyprlock hyprshot waybar awww rofi imagemagick kitty firefox

# Hyprland
mkdir -p "$DST_HYPR"
if [ ! -f "$DST_HYPR/hyprland.lua" ]; then
  cp "$SRC_HYPR/hyprland.lua" "$DST_HYPR/hyprland.lua"
fi
if [ ! -f "$DST_HYPR/hyprlock.conf" ]; then
  cp "$SRC_HYPR/hyprlock.conf" "$DST_HYPR/hyprlock.conf"
fi

# Waybar
mkdir -p "$DST_WBAR"
if [ ! -f "$DST_WBAR/change-wallpaper.sh" ]; then
  cp "$SRC_WBAR/change-wallpaper.sh" "$DST_WBAR/change-wallpaper.sh"
fi
if [ ! -f "$DST_WBAR/config.jsonc" ]; then
  cp "$SRC_WBAR/config.jsonc" "$DST_WBAR/config.jsonc"
fi
if [ ! -f "$DST_WBAR/style.css" ]; then
  cp "$SRC_WBAR/style.css" "$DST_WBAR/style.css"
fi

# rofi
mkdir -p "$DST_ROFI"
if [ ! -f "$DST_ROFI/wallpaper.rasi" ]; then
  cp "$SRC_ROFI/wallpaper.rasi" "$DST_ROFI/wallpaper.rasi"
fi

# hyprlock
