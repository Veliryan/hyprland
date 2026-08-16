require("functions")

os.execute("clear")
print("Starting install script for 'github.com/Veliryan/hyprland'")
print("")
print("")

-- @nav: package lists
local drivers = { "amd-ucode", "nvidia-open", "nvidia-utils", "lib32-nvidia-utils" }

local packages = {
  "base", "base-devel", "networkmanager", "openssh", "git", "curl", "zip", "unzip",
  "zsh",
  "kitty", "firefox", "noto-fonts", "otf-firamono-nerd", "neovim",
  "thunar", "thunar-archive-plugin", "thunar-media-tags-plugin", "thunar-volman", "xarchiver",
  "hyprland", "hyprpaper", "hyprshot", "noctalia", "greetd", "greetd-tuigreet",
  "lsd", "nodejs", "rust", "npm", "fastfetch", "steam discord"
}

local cargo_packages = { "noctalia-greeter", "pokeget" }

local missing_packages = {}

-- @nav: command lists
local install_paru_commands = {
  "sudo pacman -S --needed base-devel",
  "git clone https://aur.archlinux.org/paru.git $HOME/paru",
  "cd $HOME/paru",
  "makepkg -si",
  "cd $HOME && rm -rf paru"
}

local other_commands = {
  'chsh -s "$(which zsh)"',
  'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"',
  'git clone --depth 1 https://github.com/dexpota/kitty-themes.git ~/.config/kitty/kitty-themes',
  'mkdir $HOME/.config/fastfetch && curl -o $HOME/.config/fastfetch/pokemon.sh https://github.com/Discomanfulanito/pokefetch/blob/main/pokemon.sh',
  'git clone https://github.com/Veliryan/nvim $HOME/.config/nvim'
}

local copy_commands = {
  { "greetd",   "/etc/greetd/",         "config.toml" },
  { "hyprland", "$HOME/.config/hypr/",  "hyprland.lua" },
  { "kitty",    "$HOME/.config/kitty/", "kitty.conf" },
  { "xfce4",    "$HOME/.config/xfce4/", "helpers.rc" },
  { "zsh",      "$HOME/",               ".zshrc" }
}


-- @nav: drivers
print("CPU: Amd Ryzen 5 7600X")
print("GPU: RTX3090")
print("")
print(
  "Note if your hardware does not match or you do not want to instal it here, please make sure to install the drivers yourself.")
print("Would you like to install the drivers for this hardware?(y/n)")
local answer = io.read()
if answer == "y" then
  do_install_list(drivers)
end


-- @nav: packages
do_install_list(packages)

-- @nav: paru
os.execute(table.concat(install_paru_commands, " && "))
os.execute("paru -S --needed " .. table.concat(cargo_packages, " "))


-- @anv: other
for _, val in ipairs(other_commands) do
  os.execute(val)
end

-- @nav: copy
for _, val in ipairs(copy_comands) do
  copy_file(val[1], val[2], val[3])
end


os.execute("sudo systemctl enable greetd")
