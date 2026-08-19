#!/bin/sh

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_DIR="$HOME/.cache/waybar/wallpapers"

mkdir -p "$CACHE_DIR"

# Thumbnails erstellen
find "$WALLPAPER_DIR" -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) |
while IFS= read -r wallpaper; do
    name=$(basename "$wallpaper")
    thumbnail="$CACHE_DIR/$name.png"

    if [ ! -f "$thumbnail" ] || [ "$wallpaper" -nt "$thumbnail" ]; then
        magick "$wallpaper" \
            -thumbnail 320x200^ \
            -gravity center \
            -extent 320x200 \
            "$thumbnail"
    fi
done

# Wallpaper auswählen
selected=$(
    find "$WALLPAPER_DIR" -type f \
        \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) |
    while IFS= read -r wallpaper; do
        name=$(basename "$wallpaper")
        thumbnail="$CACHE_DIR/$name.png"

        printf '%s\0icon\x1f%s\n' "$name" "$thumbnail"
    done |
    rofi \
        -dmenu \
        -i \
        -show-icons \
        -p "󰸉  Wallpaper" \
        -theme "$HOME/.config/rofi/wallpaper.rasi"
)

[ -n "$selected" ] || exit 0

awww img "$WALLPAPER_DIR/$selected" \
    --transition-type any \
    --transition-duration 1
