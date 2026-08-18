$env.config.show_banner = false

alias l = ls -a
alias nv = nvim
alias py = python
alias y = yazi

def cl [] {
  clear
  ls -a
}

def ff [] {
  ^sh $"($env.HOME)/.config/fastfetch/pokemon.sh"
}


^clear
ff
