use utils.nu *

export def install_paru [] {
  let current_dir = (pwd)
  let build_dir = ($current_dir | path join "paru")
  ^sudo pacman -S --needed base-devel git ; git clone https://aur.archlinux.org/paru.git $build_dir ; cd $build_dir ; makepkg -si ; cd current_dir ; rm -rf $build_dir
}

export def install_package_list [pkg_list: list<string>] {
  if not (is_installed "paru") {
    install_paru 
  }
  ^paru -S --needed ...$pkg_list  
}
