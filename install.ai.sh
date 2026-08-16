```bash
#!/bin/bash

set -e

path="$(pwd)"
conf="$(pwd)/configs"

# @nav: functions

is_installed() {
    if pacman -Q "$1" &> /dev/null; then
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

    mkdir -p "$dest"

    if is_found "$dest$name"; then
        mv "$dest$name" "$dest$name.old"
    fi

    cp "$src" "$dest$name"
}


# @nav: phase handling

MARKER="$HOME/.install_phase1_done"
SERVICE="/etc/systemd/system/install-continue.service"


# ============================================================
# PHASE 2
# Wird nach dem ersten Neustart automatisch ausgeführt
# ============================================================

if [[ -f "$MARKER" ]]; then

    echo
    echo "=========================================="
    echo " Phase 2: Oh My Zsh"
    echo "=========================================="
    echo

    echo "Installiere Oh My Zsh..."

    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        RUNZSH=no CHSH=no sh -c \
            "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        echo "Oh My Zsh ist bereits installiert."
    fi

    echo
    echo "Oh My Zsh wurde installiert."

    # Service entfernen
    sudo systemctl disable install-continue.service 2>/dev/null || true
    sudo rm -f "$SERVICE"

    # Marker entfernen
    rm -f "$MARKER"

    # systemd neu laden
    sudo systemctl daemon-reload

    echo
    echo "=========================================="
    echo " Installation abgeschlossen!"
    echo " Das System wird jetzt erneut gestartet."
    echo "=========================================="
    echo

    sleep 3

    sudo reboot
    exit 0
fi


# ============================================================
# PHASE 1
# Grundinstallation
# ============================================================

echo
echo "=========================================="
echo " Phase 1: Grundinstallation"
echo "=========================================="
echo


# @nav: packages

# package lists
drivers=(
    "amd-ucode"
    "nvidia-open"
    "nvidia-utils"
    "lib32-nvidia-utils"
)

packages=(
    "base"
    "base-devel"
    "networkmanager"
    "git"
    "curl"
    "openssh"
    "zip"
    "unzip"
    "zsh"
    "kitty"
    "firefox"
    "noto-fonts"
    "otf-firamono-nerd"
    "neovim"
    "thunar"
    "thunar-archive-plugin"
    "thunar-media-tags-plugin"
    "thunar-volman"
    "xarchiver"
    "hyprland"
    "hyprpaper"
    "hyprshot"
    "noctalia"
    "greetd"
    "lsd"
    "nodejs"
    "rust"
    "npm"
    "fastfetch"
    "steam"
    "discord"
)

paru=(
    "noctalia-greeter"
    "pokeget"
    "google-chrome"
)


# @nav: package install pacman

echo "Installiere Pacman-Pakete..."

do_install_list "${drivers[*]} ${packages[*]}"


# ============================================================
# PARU
# ============================================================

echo
echo "=========================================="
echo " Installiere paru"
echo "=========================================="
echo

if ! command -v paru &> /dev/null; then

    sudo pacman -S --needed base-devel

    if [[ ! -d "paru" ]]; then
        git clone https://aur.archlinux.org/paru.git
    fi

    cd paru
    makepkg -si --noconfirm
    cd "$path"

else
    echo "paru ist bereits installiert."
fi


# @nav: package install paru

echo
echo "Installiere AUR-Pakete..."

do_install_paru_list "${paru[*]}"


# ============================================================
# EXTRA PACKAGES
# ============================================================

extra=(
    "visual-studio-bin"
)

echo
echo "Zusätzliche Software:"
echo "${extra[*]}"
echo

read -p "Would you like to install the extra Software? (y/n) " answer

if [[ "$answer" =~ ^[Yy]$ ]]; then
    do_install_paru_list "${extra[*]}"
fi


# ============================================================
# EXTRA CONFIG / THEMES
# ============================================================

echo
echo "Installiere Kitty Themes..."

if [[ ! -d "$HOME/.config/kitty/kitty-themes" ]]; then
    mkdir -p "$HOME/.config/kitty"

    git clone \
        --depth 1 \
        https://github.com/dexpota/kitty-themes.git \
        "$HOME/.config/kitty/kitty-themes"
fi


echo "Installiere Fastfetch Pokemon Script..."

mkdir -p "$HOME/.config/fastfetch"

curl -fsSL \
    -o "$HOME/.config/fastfetch/pokemon.sh" \
    https://raw.githubusercontent.com/Discomanfulanito/pokefetch/refs/heads/main/pokemon.sh


# ============================================================
# CONFIG
# ============================================================

echo
echo "=========================================="
echo " Installiere Config-Dateien"
echo "=========================================="
echo


# @nav: system files

sudo mkdir -p /etc/greetd/

sudo rm -f /etc/greetd/config.toml

sudo cp \
    "${conf}/greetd" \
    "/etc/greetd/config.toml"


# @nav: user files

copy_file \
    "${conf}/hyprland" \
    "$HOME/.config/hypr/" \
    "hyprland.lua"

copy_file \
    "${conf}/kitty" \
    "$HOME/.config/kitty/" \
    "kitty.conf"

copy_file \
    "${conf}/xfce4" \
    "$HOME/.config/xfce4/" \
    "helpers.rc"

copy_file \
    "${conf}/zsh" \
    "$HOME/" \
    ".zshrc"


# ============================================================
# SERVICES
# ============================================================

echo
echo "Aktiviere greetd..."

sudo systemctl enable greetd


# ============================================================
# AUTO CONTINUE SERVICE
# ============================================================

echo
echo "Konfiguriere automatisches Fortsetzen nach dem Neustart..."

touch "$MARKER"

sudo tee "$SERVICE" > /dev/null <<EOF
[Unit]
Description=Continue installation script
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
User=$USER
WorkingDirectory=$path
ExecStart=$path/install.sh
RemainAfterExit=no

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable install-continue.service


# ============================================================
# FIRST REBOOT
# ============================================================

echo
echo "=========================================="
echo " Phase 1 abgeschlossen!"
echo "=========================================="
echo
echo "Das System wird jetzt neu gestartet."
echo "Nach dem Neustart wird automatisch"
echo "Oh My Zsh installiert."
echo

sleep 3

sudo reboot
```

