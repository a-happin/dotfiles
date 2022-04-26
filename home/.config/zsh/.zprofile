#------------------------------
# PATH
#------------------------------
USER_PATH=
[[ -d "${HOME}/bin" ]] && USER_PATH="${USER_PATH}:${HOME}/bin"
[[ -d "${HOME}/.cargo/bin" ]] && USER_PATH="${USER_PATH}:${HOME}/.cargo/bin"
[[ -d "${HOME}/.deno/bin" ]] && USER_PATH="${USER_PATH}:${HOME}/.deno/bin"
[[ -d "${HOME}/.nodebrew/current/bin" ]] && USER_PATH="${USER_PATH}:${HOME}/.nodebrew/current/bin"
[[ -d "${HOME}/.fzf/bin" ]] && USER_PATH="${USER_PATH}:${HOME}/.fzf/bin"
[[ -n "$USER_PATH" ]] && export PATH="${USER_PATH}:${PATH}"
unset USER_PATH

#export LD_LIBRARY_PATH="${HOME}/lib"


#------------------------------
# VTE_CJK_WIDTH
#------------------------------
#export VTE_CJK_WIDTH=1


#------------------------------
# fzf
#------------------------------
export FZF_DEFAULT_COMMAND='fd --type f --hidden --no-ignore --exclude .git'


#------------------------------
# set i3-sensible-terminal
#------------------------------
type alacritty >/dev/null 2>&1 && export TERMINAL='alacritty'


#------------------------------
# launch X
#------------------------------
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && startx -- -keeptty
