#------------------------------
# USER_PATH
#------------------------------
local USER_PATH="${HOME}/bin:${HOME}/.cargo/bin:${HOME}/.deno/bin"


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
# 環境依存
#------------------------------
case ${OSTYPE} in
  darwin*)
    # ここに Mac 向けの設定
    # alias ls='\ls -G -F'
    ;;
  linux*)
    # ここに Linux 向けの設定
    # alias ls='\ls --color=auto -F'
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
    alias open=xdg-open
    ;;
esac

# WSL Windows
if [[ $(uname -r) =~ Microsoft$ ]]
then
  USER_PATH="${USER_PATH}:${HOME}/.nodebrew/current/bin:${HOME}/.fzf/bin"
  export DISPLAY=localhost:0

  alias pbcopy=clip.exe
  alias pbpaste='powershell.exe get-clipboard'
  alias open='powershell.exe start'

  alias explorer=explorer.exe
  alias java=java.exe
  alias ffmpeg=ffmpeg.exe
  alias ffprobe=ffprobe.exe
  alias ffplay=ffplay.exe
fi

#------------------------------
# PATH
#------------------------------
export PATH="${USER_PATH}:${PATH}"
#export LD_LIBRARY_PATH="${HOME}/lib"

#------------------------------
# launch X
#------------------------------
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && startx -- -keeptty
