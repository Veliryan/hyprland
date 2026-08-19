#!/bin/sh

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_DIR="$HOME/.cache/waybar/wallpapers"

mkdir -p "$CACHE_DIR"

find "$WALLPAPER_DIR" -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" -o -iname "*.mp4" \) |
while IFS= read -r wallpaper; do
    name=$(basename "$wallpaper")
    thumbnail="$CACHE_DIR/$name.png"

    if [ ! -f "$thumbnail" ] || [ "$wallpaper" -nt "$thumbnail" ]; then
        case "$wallpaper" in
            *.mp4|*.MP4)
                ffmpeg -y -i "$wallpaper" \
                    -vf "thumbnail,scale=320:200:force_original_aspect_ratio=increase,crop=320:200" \
                    -frames:v 1 \
                    "$thumbnail" \
                    >/dev/null 2>&1
                ;;

            *.gif|*.GIF)
                magick "$wallpaper[0]" \
                    -thumbnail 320x200^ \
                    -gravity center \
                    -extent 320x200 \
                    "$thumbnail"
                ;;

            *)
                magick "$wallpaper" \
                    -thumbnail 320x200^ \
                    -gravity center \
                    -extent 320x200 \
                    "$thumbnail"
                ;;
        esac
    fi
done

selected=$(
    find "$WALLPAPER_DIR" -type f \
      \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" -o -iname "*.mp4" \) |
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

