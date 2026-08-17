#!/bin/bash

conf="$(pwd)/configs"
vids="$(pwd)/vids"

# @nav: functions
is_installed() {
    pacman -Q "$1" &> /dev/null
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
packages=("base" "base-devel" "networkmanager" "git" "curl" "openssh" "zip" "unzip" "zsh" "kitty" "htop" "btop" "firefox" "noto-fonts" "otf-firamono-nerd" "neovim" "thunar" "thunar-archive-plugin" "thunar-media-tags-plugin" "thunar-volman" "xarchiver" "hyprland" "hyprpaper" "hyprshot" "noctalia" "greetd" "lsd" "nodejs" "rust" "npm" "fastfetch" "hdparm" "steam" "discord" "udisks2" "polkit" "gvfs" "gnome-disk-utility" "polkit-gnome" "udiskie")
paru=("noctalia-greeter" "pokeget" "google-chrome" "mpv" "mpvpaper")
neovim_dep=("neovim" "git" "ripgrep" "fd" "tar" "curl" "tree-sitter" "tree-sitter-cli" "gcc" "npm" "zip" "unzip")

# install paru
if ! is_installed "paru"; then
    sudo pacman -S --needed base-devel
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si 
fi

# package install paru
do_install_paru_list "${drivers[*]} ${packages[*]} ${paru[*]}"

# else
if ! [ -d "$HOME/.config/kitty/kitty-themes" ]; then
    git clone --depth 1 https://github.com/dexpota/kitty-themes.git ~/.config/kitty/kitty-themes
fi
if ! [ -d "$HOME/.config/fastfetch" ]; then
    mkdir -p $HOME/.config/fastfetch
    curl -o $HOME/.config/fastfetch/pokemon.sh https://raw.githubusercontent.com/Discomanfulanito/pokefetch/refs/heads/main/pokemon.sh
fi

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

# @nav: systemctl
sudo systemctl enable greetd
sudo systemctl enable udisks2

# @nav: oh-my-zsh / ohmyzsh
if ! [ -d "$HOME/.oh-my-zsh" ]; then
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# @nav: neovim / nvim
if ! [ -d "$HOME/.config/nvim" ]; then
    git clone https://github.com/Veliryan/nvim $HOME/.config/nvim
fi

rm -f $HOME/.bash*
rm -f $HOME/.shell.pre-oh-my-zsh
rm -f $HOME/.zcompdump-*

mkdir -p $HOME/Documents $HOME/Downloads $HOME/Pictures $HOME/Pictures/Wallpapers $HOME/Music $HOME/Videos

# @nav: wallpaper
# setup noctalia/mpvpaper
# this should actually only be done after a restart but it does not hurt to have it in here
noctalia msg plugins enable noctalia/mpvpaper
CONFIG="$HOME/.local/state/noctalia/settings.toml"
if ! grep -q '^[[:space:]]*start = .*"mpvpaper"' "$CONFIG"; then
    sed -i '/^\[bar\.default\]/,/^\[/ {
        s/^start = \[ /start = [ "mpvpaper", /
    }' "$CONFIG"

    noctalia msg config-reload
fi
cp "${vids}/bottle.mp4" $HOME/Videos/
cp "${vids}/pokemon-emerald-may.mp4" $HOME/Videos/
cp "${vids}/terraria-snow.mp4" $HOME/Videos/

# @nav: reboot
read -p "Would you like to reboot?(y/n)" do_reboot
if [[ "$do_reboot" =~ ^[Yy]$ ]]; then
  reboot
fi
