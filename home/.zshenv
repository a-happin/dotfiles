#------------------------------
# XDG Base Directory
#------------------------------
export XDG_CONFIG_HOME=${HOME}/.config
export XDG_CACHE_HOME=${HOME}/.cache
export XDG_DATA_HOME=${HOME}/.local/share

#------------------------------
# ZDOTDIR
#------------------------------
export ZDOTDIR=${XDG_CONFIG_HOME}/zsh

#------------------------------
# EDITOR
#------------------------------
type nvim > /dev/null 2>&1 && {
  export EDITOR=nvim
  export VISUAL=nvim
}

: