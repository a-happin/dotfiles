#------------------------------
# PATH
#------------------------------
typeset -U PATH path
path=(
  "${HOME}/bin"(N-/)
  "${HOME}/.cargo/bin"(N-/)
  "${HOME}/.deno/bin"(N-/)
  "${HOME}/.nodebrew/current/bin"(N-/)
  "${HOME}/.fzf/bin"(N-/)
  "${path[@]}"
)

#export LD_LIBRARY_PATH="${HOME}/lib"


#------------------------------
# EDITOR
#------------------------------
type nvim > /dev/null 2>&1 && {
  export EDITOR=nvim
  export VISUAL=nvim
}


#------------------------------
# VTE_CJK_WIDTH
#------------------------------
#export VTE_CJK_WIDTH=1


#------------------------------
# set i3-sensible-terminal
#------------------------------
type alacritty >/dev/null 2>&1 && export TERMINAL='alacritty'


#------------------------------
# launch X
#------------------------------
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && startx -- -keeptty
