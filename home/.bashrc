#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# type fish > /dev/null 2>&1 && {
#   shopt -q login_shell && exec fish -l || exec fish
# }
:
