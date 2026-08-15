os.execute("clear")

print("Install Script for a quick hyprland setup and customizations.")

if os.execute("which pacman") == 0 then
  print("====== ===== ===== ===== ==== ")
  print("")
  print("This Script is only meant for Arch Linux.")
  print("Pacman was not found so the Script will end.")
  print("You can still use it as a reference but don't expect it to work.")
  print("")
  print("====== ===== ===== ===== ==== ")
  return
end

-- helper function
local function is_installed(command)
  local result = os.execute("command -v " .. command .. " > /dev/null 2>&1")
  return result == true or result == 0
end

local function do_install(pkgs)
  os.execute("sudo pacman -S --needed " .. table.concat(pkgs, " "))
end

-- set zsh as default
if not is_installed("zsh") then
  print("")
  print("")
  os.execute("sudo pacman -S --needed zsh zsh-autosuggestions zsh-completions")
  os.execute("chsh -s '$(which zsh)'")
end

-- organization or bs like that
local folders = { "Downloads", "Docments", "Pictures", "Pictures/Wallpaper", "Videos", "Music", ".config", ".config/hypr",
  ".config/noctalia" }
for _, name in ipairs(folders) do
  os.execute("mkdir " .. name)
end
os.execute("cp hyprland.lua $HOME/.config/hypr/")
os.execute("cp config $HOME/.config/noctalia/")
os.execute("cp ./arch-linux-01.jpeg $HOME/Pictures/Wallpaper/")

-- install all dependencies
local dependencies = { "kitty", "neovim", "sddm", "hyprland", "hyprpaper", "hyprshot", "noctalia", "thunar", "firefox",
  "git", "base-devel", "playerctl" }
print("")
print("")
do_install(dependencies)


-- install an paru helper
if not is_installed("paru") then
  print("")
  print("")
  os.execute("git clone https://aur.archlinux.org/paru.git")
  os.execute("cd paru")
  os.execute("makepkg -si")
  os.execute("cd .. && rm -rf paru")
end

-- custom
print("")
print("")
print("Would you like to install drivers for the following hardware?")
print("CPU: Amd Ryzen 5 7600X")
print("GPU: RTX3090")
print("CHOOSE, do it you coward(y/n)")
local answer = io.input()
if answer == "y" then
  local drivers = { "amd-ucode", "nvidia-open", "nvidia-utils", "lib32-nvidia-utils" }
  do_install(drivers)
end

-- extra softwaer
local extra_software = { "gamemode", "steam", "discord", "htop", "btop" }
print("")
print("")
print("Extra Software: " .. table.concat(extra_software, " "))
print("Would you like to install some extra Software?(y/n)")
local answer = io.input()
if answer == "y" then
  do_install(extra_software)
end

-- neovim config
print("")
print("")
os.execute("git clone https://github.com/Veliryan/nvim $HOME/.config/")
os.execute("cd $HOME/.config/nvim && lua install.lua")

-- sddm stuff
print("")
print("")
os.execute("sudo systemctl enable sddm.service")
os.execute('bash -c "$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)"')
