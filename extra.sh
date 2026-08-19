#!/bin/sh
set -e

if ! command -v paru >/dev/null 2>&1; then
  chmod +x paru.sh
  ./paru.sh
fi

paru -S --needed --noconfirm steam discord google-chrome strawberry noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra nerd-fonts
