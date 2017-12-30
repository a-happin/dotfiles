#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)
#export LANG=ja_JP.UTF-8
export LC_CTYPE=ja_JP.UTF-8

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# xrdb
#xrdb ${HOME}/.Xresources

# fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
#fcitx-autostart

# disable touchpad while typing (by keyboard)
#   -i n -- enable after n seconds.
#   -k   -- ignore ctrl (enable ctrl + click)
type syndaemon && syndaemon -i 0.5 -k -d

# キーリピート開始まで350ms、キーリピート間隔50ms
xset r rate 350 50

# バックライトを切らない
# keep screen on
xset dpms 0 0 0; xset s off

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice
# exec awesome
# exec xmonad
exec i3

