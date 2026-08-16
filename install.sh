#!/bin/bash

path="$(pwd)"
conf="$(pwd)/configs"

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
  paru -S --needed $1
}

copy_file() {
  src=$1
  dest=$2
  name=$3
  
  mkdir -p $dest
  if is_found "$dest$name"; then
    mv "$dest$name" "$dest$name.old"
  fi

  cp "$src" "$dest$name"
}

# @nav: packages
# package lists
drivers=("amd-ucode" "nvidia-open" "nvidia-utils" "lib32-nvidia-utils")
packages=("base" "base-devel" "networkmanager" "git" "curl" "openssh" "zip" "unzip" "zsh" "kitty" "firefox" "noto-fonts" "otf-firamono-nerd" "neovim" "thunar" "thunar-archive-plugin" "thunar-media-tags-plugin" "thunar-volman" "xarchiver" "hyprland" "hyprpaper" "hyprshot" "noctalia" "greetd" "lsd" "nodejs" "rust" "npm" "fastfetch" "steam" "discord")
paru=("noctalia-greeter" "pokeget" "google-chrome")

# package install pacman
do_install_list "${drivers[*]} ${packages[*]}"

# install paru
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si 

# package install paru
do_install_paru_list "${paru[*]}"

# extra packages
extra=("visual-studio-bin")
echo "${extra[*]}"
read -p "Would you like to install the extra Software?(y/n)" answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
  do_install_paru_list "${extra[*]}"
fi

# else
git clone --depth 1 https://github.com/dexpota/kitty-themes.git ~/.config/kitty/kitty-themes
mkdir -p $HOME/.config/fastfetch && curl -o $HOME/.config/fastfetch/pokemon.sh https://raw.githubusercontent.com/Discomanfulanito/pokefetch/refs/heads/main/pokemon.sh

# @nav: config
# system files 
sudo mkdir -p /etc/greetd/
sudo rm -f /etc/greetd/config.toml
sudo cp "${conf}/greetd" "/etc/greetd/config.toml"
# user files
copy_file "${conf}/hyprland" "$HOME/.config/hypr/" "hyprland.lua"
copy_file "${conf}/kitty" "$HOME/.config/kitty/" "kitty.conf"
copy_file "${conf}/xfce4" "$HOME/.config/xfce4/" "helpers.rc"
copy_file "${conf}/zsh" "$HOME/" ".zshrc"

sudo systemctl enable greetd

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

read -p "Would you like to reboot?" do_reboot
if [[ "$do_reboot" =~ ^[Yy]$ ]]; then
  reboot
fi

