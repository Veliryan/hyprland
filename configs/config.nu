alias l = ls -a
alias nv = nvim
alias py = python

def cl [] {
  clear
  ls -a
}

def ff [] {
  ^sh $"($env.HOME)/.config/fastfetch/pokemon.sh"
}


^clear
ff
