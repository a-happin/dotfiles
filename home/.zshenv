#------------------------------
# startuptime
#------------------------------
# zmodload zsh/zprof && zprof


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
# disable auto compinit
#------------------------------
skip_global_compinit=1

:
