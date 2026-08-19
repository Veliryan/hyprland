#!/bin/sh
set -e

if ! command -v paru >/dev/null 2>&1; then
  chmod +x paru.sh
  ./paru.sh 
fi

paru -S --needed --noconfirm thunar thunar-archive-plugin thunar-media-tags-plugins thunar-volman xarchiver polkit gvfs
