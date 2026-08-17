#!/usr/bin/env nu
use lib/utils.nu *
use lib/packages.nu *

let pkg = (open "lib/packages.toml").packages
let config_dir = ($env.HOME | path join ".config")
let src_cfg = (pwd | path join "configs")

# Selection
^clear

mut selection = {}
for name in ($pkg | columns) {
  print $"List: ($name)"
  print ($pkg | get $name)

  let answer = (input "Install List?(y/n) Default=y")
  let selected = ($answer != "n")
  $selection = ($selection | insert $name $selected)
}

# Concatinating selected lists
let pkg_list = (
    $selection
    | columns
    | where {|name| $selection | get $name}
    | each {|name| $pkg | get $name}
    | flatten
)

# Install Packages
^clear
print $pkg_list
install_package_list $pkg_list

# Config movement
## Greetd
do_copy_file ($src_cfg | path join "greetd") "/etc/greetd/config.toml" true

## Kitty
if not (is_found ($config_dir | path join "kitty/kitty-themes")) {
  ^mkdir -p ($config_dir | path join "kitty")
  ^mkdir -p ($config_dir | path join "kitty/kitty-themes")
  ^git clone --depth 1 https://github.com/dexpota/kitty-themes.git ($config_dir | path join "kitty/kitty-themes")
  do_copy_file ($src_cfg | path join "kitty") ($config_dir | path join "kitty.conf")
}

## Neovim
do_backup_file ($config_dir | path join "nvim")
^git clone https://github.com/Veliryan/nvim ($config_dir | path join "nvim")

## Fastfetch
if not (is_found ($config_dir | path join "fastfetch/pokemon.sh")) {
  ^mkdir -p ($config_dir | path join "fastfetch")
  ^curl -o ($config_dir | path join "fastfetch/pokemon.sh") https://raw.githubusercontent.com/Discomanfulanito/pokefetch/refs/heads/main/pokemon.sh
}

## Hyprland
do_copy_file ($src_cfg | path join "hyprland") ($config_dir | path join "hypr/hyprland.lua")

## Xfce4
do_copy_file ($src_cfg | path join "xfce4") ($config_dir | path join "xfce4/helpers.rc")

## Nushell
do_copy_file ($src_cfg | path join "config.nu") ($config_dir | path join "nushell/config.nu")
do_copy_file ($src_cfg | path join "env.nu") ($config_dir | path join "nushell/env.nu")


# Systemctl 
run_command "system" ["enable", "greetd"] true
run_command "system" ["enable", "udisks2"] true

# Create Home Folder structure
run_command "mkdir" ["-p", ($env.HOME | path join "Documents")]
run_command "mkdir" ["-p", ($env.HOME | path join "Downloads")]
run_command "mkdir" ["-p", ($env.HOME | path join "Music")]
run_command "mkdir" ["-p", ($env.HOME | path join "Pictures")]
run_command "mkdir" ["-p", ($env.HOME | path join "Pictures/Wallpapers")]
run_command "mkdir" ["-p", ($env.HOME | path join "Videos")]
