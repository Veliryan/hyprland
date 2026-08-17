export def is_installed [pkg: string] {
  (pacman -Q $pkg | complete).exit_code == 0
}

export def is_found [file_or_folder: string] {
  ($file_or_folder | path exists)
}

def run_command [command: string, args: list<string>, use_sudo: bool] {
  if $use_sudo {
    ^sudo $command ...$args
  } else {
    ^$command ...$args
  }
}

export def do_backup_file [dst_file: string, use_sudo: bool = false] {
  if (is_found $dst_file) {
    let backup = $"($dst_file).old"
    run_command "mv" [$dst_file, $backup] $use_sudo
  } else {
    let dst_file_dir = (($dst_file | path parse).parent)
    run_command "mkdir" ["-p", $dst_file_dir] $use_sudo
  }
}

export def do_copy_file [src_file: string, dst_file: string, use_sudo: bool = false] {
  do_backup_file $dst_file $use_sudo
  run_command "cp" [$src_file, $dst_file] $use_sudo
}
