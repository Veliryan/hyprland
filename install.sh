#!/bin/bash

# @nav: functions
is_installed() {
    if dpkg -s "$1" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

is_found() {
    if [[ -f "$1" ]]; then
        return 0
    else
        return 1
    fi
}

# do_install_list "${<var>[*]}"
do_install_list() {
  sudo pacman -S --needed $1
}

do_install_paru_list() {
  sudo cargo install -S --needed $1
}

copy_file() {
  src=$1
  dest=$2
  name=$3
  
  sudo mkdir -p $dest
  if is_found "$2$3"; then
    sudo mv "$2$3" "$2$3.old"
  fi

  sudo cp "$1" "$2$3"
}

# @nav: packages
# package lists
drivers=("amd-ucode" "nvidia-open" "nvidia-utils" "lib32-nvidia-utils")
packages=("base" "base-devel" "networkmanager" "git" "curl" "openssh" "zip" "unzip" "zsh" "kitty" "firefox" "noto-fonts" "otf-firamono-nerd" "neovim" "thunar" "thunar-archive-plugin" "thunar-media-tags-plugin" "thunar-volman" "xarchiver" "hyprland" "hyprpaper" "hyprshot" "noctalia" "greetd" "greetd-tuigreet" "lsd" "nodejs" "rust" "npm" "fastfetch" "steam" "discord")
paru=("noctalia-greeter" "pokeget")

# package install pacman
do_install_list "${drivers[*]} ${packages[*]}"

# install paru
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si 

# package install cargo
do_install_cargo_list "${paru[*]}"

# @nav: configs
copy_file "./configs/greetd" "/etc/greetd/" "config.toml"
copy_file "./configs/hyprland" "$HOME/.config/hypr/" "hyprland.lua"
copy_file "./configs/kitty" "$HOME/.config/kitty/" "kitty.conf"
copy_file "./configs/xfce4" "$HOME/.config/xfce4/" "helpers.rc"
copy_file "./configs/zsh" "$HOME/" ".zshrc"

sudo systemctl enable greetd
reboot
