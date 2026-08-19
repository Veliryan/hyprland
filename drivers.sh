#!/bin/sh
set -e

if ! command -v paru >/dev/null 2>&1; then
  chmod +x paru.sh
  ./paru.sh
fi

paru -S --needed --noconfirm amd-ucode nvidia-open nvidia-utils lib32-nvidia-utils
