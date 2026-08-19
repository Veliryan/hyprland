#!/bin/sh
set -e

chmod +x *.sh

# did not use ./* to make sure, that the user action is close together

# no user interaction
./create_dir.sh
./drivers.sh
./basics.sh
./file_manager.sh
./hyprland.sh
./terminal.sh
./tmux.sh
./extra.sh
./devkit.sh
./neovim.sh

# user interaction
./zsh.sh
./greeter.sh
