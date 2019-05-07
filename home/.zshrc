
########################################
# 補完

# 補完を有効にする
autoload -Uz compinit && compinit

# 先方予測機能
#autoload -Uz predict-on && predict-on

# 自動補完される余分なカンマなどを適宜削除してスムーズに入力できるようにする
setopt auto_param_keys

# コマンドライン引数で --prefix=/usr などの=以降でも補完する
setopt magic_equal_subst

# ファイルの種別を識別マーク表示
setopt list_types

# 補完候補をできるだけ詰めて表示する
setopt list_packed

# TAB補完時にメニューっぽくする
setopt auto_menu

# カーソル位置で補完する
setopt complete_in_word

# globを展開しないで候補の一覧から補完する
setopt glob_complete

# 補完時にヒストリを展開
setopt hist_expand

# エイリアス？
setopt complete_aliases

# 隠しファイルも補完する
setopt globdots

# ディレクトリにマッチした場合末尾に'/'をつける
setopt mark_dirs

# ビープ音を鳴らさない
setopt no_beep

# 数値順にソート(辞書順ではなく)
setopt numeric_glob_sort

# 補完で小文字を大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 補完メニューを選択できるようにする
zstyle ':completion:*:default' menu select=2

# 補完候補をグループ化
zstyle ':completion:*' format '%B%d%b'
zstyle ':completion:*' group-name ''

# 補完候補に色をつける
zstyle ':completion:*:default' list-colors ""

# 補完候補の指定
# _oldlist: 前回の補完結果を再利用する。
# _complete: 補完する。(?)
# _match: globを展開しないで候補の一覧から補完する。
# _history: ヒストリのコマンドも補完候補とする。
# _ignored: 補完候補に出さないと指定したものも補完候補とする。
# _approximate: 似ている補完候補も補完候補とする。
# _prefix: カーソル以降を無視してカーソル位置までで補完する。
zstyle ':completion:*' completer _oldlist _complete _match _approximate _prefix

# 補完キャッシュを使わない
zstyle ':completion:*' use-cache no

# 詳細な情報を使う
zstyle ':completion:*' verbose yes

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後のコマンド名補完
zstyle ':completion:*:sudo:*' command-path /bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin /opt/bin

# ps の後のプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

# 補完してほしくないファイルは補完しない
zstyle ':completion:*:*:nvim:*:*files' ignored-patterns '*?.out' '*?.o' '*?.hi' '*?~' '*\#'
zstyle ':completion:*' ignored-patterns '.git'

########################################
# 設定

# コマンドのスペルを修正する
# setopt correct correct_all

# '#'以降をコメントとみなす
setopt interactive_comments

# Ctrl-dでログアウトしない
setopt ignore_eof

# Ctrl+Sで停止を無効
# stty stop undef

# Ctrl+Qで再開を無効
# stty start undef

# Ctrl+Sとかを使わない設定(?)
setopt no_flow_control

# 終了コードが0以外の時それを表示
# PROMPTで代用しました
#setopt print_exit_value

# ディレクトリ末尾の/を消す
setopt auto_remove_slash

########################################
# 表示

# 色を付ける
autoload -Uz colors && colors

# 文字化け対策
setopt print_eight_bit

########################################
# jobs

# バックグラウンドジョブの状態変化を即時報告する
setopt notify

# ログアウト時にバックグラウンドジョブをkillしない
setopt no_hup

# jobsでプロセスIDも出力する
setopt long_list_jobs

# 3秒以上かかった処理は詳細表示
REPORTTIME=2

########################################
# vcs_info

#autoload -Uz vcs_info
#zstyle ':vcs_info:*' max-exports 4
#zstyle ':vcs_info:*' formats '%s' '%b'
#zstyle ':vcs_info:*' actionformats '%s' '%b' '' '|%a'
#
#zstyle ':vcs_info:git:*' check-for-changes true # %cと%uを有効にする(でかいリポジトリだと重いらしい)
#zstyle ':vcs_info:git:*' formats '%s' '%b' '%u%c'
#zstyle ':vcs_info:git:*' actionformats '%s' '%b' '%u%c' '|%a'

#function decorate-branch_old ()
#{
#  LANG=en_US.UTF-8 vcs_info
#  [[ -n ${vcs_info_msg_0_} ]] &&
#  {
#    if [[ -n ${vcs_info_msg_3_} ]]
#    then
#      echo -e -n %{${fg_bold[red]}%}
#    elif [[ -n ${vcs_info_msg_2_} ]]
#    then
#      echo -e -n %{${fg_bold[yellow]}%}
#    else
#      echo -e -n %{${fg_bold[cyan]}%}
#    fi
#    echo -n "(${vcs_info_msg_0_})-[${vcs_info_msg_1_}${vcs_info_msg_3_}]${vcs_info_msg_2_}"
#    echo -e -n %{${reset_color}%}
#  }
#}

# デコ
function decorate-branch_impl ()
{
  typeset -A git_info
  local line

  git_info[untracked]=0
  git_info[staged]=0
  git_info[modified]=0

  if read line
  then
    git_info[branch]=${${line}#* }
    while IFS= read line
    do
      case "${line[1,2]}" in
        \?\?) ((++git_info[untracked])) ;;
        ?\ ) ((++git_info[staged])) ;;
        \ ?) ((++git_info[modified])) ;;
        *)
          ((++git_info[staged]))
          ((++git_info[modified]))
          ;;
      esac
    done
    if [[ ${git_info[untracked]} -ne 0 ]]
    then
      printf "%s" "%{${fg_bold[red]}%}"
    elif [[ ${git_info[staged]} -ne 0 || ${git_info[modified]} -ne 0 ]]
    then
      printf "%s" "%{${fg_bold[yellow]}%}"
    else
      printf "%s" "%{${fg_bold[cyan]}%}"
    fi
    printf "(%s)" ${git_info[branch]}
    [[ ${git_info[staged]} -ne 0 ]] && printf "%s %d staged" "%{${fg_bold[green]}%}" ${git_info[staged]}
    [[ ${git_info[modified]} -ne 0 ]] && printf "%s %d modified" "%{${fg_bold[yellow]}%}" ${git_info[modified]}
    [[ ${git_info[untracked]} -ne 0 ]] && printf "%s %d untracked" "%{${fg_bold[red]}%}" ${git_info[untracked]}
  fi
}

function decorate-branch ()
{
  \git status --porcelain --branch 2> /dev/null | decorate-branch_impl
}

function decorate-prompt ()
{
  readonly local exit_code=$?
  printf "%s\n" "%{${reset_color}%}"
  [[ ${exit_code} -eq 0 ]] || printf "%s" "%{${fg_bold[red]}%}${exit_code} "
  case "${USER}" in
    root) printf "%s" "%{${fg_bold[red]}%}" ;;
    *) printf "%s" "%{${fg_bold[green]}%}" ;;
  esac
  printf "%s\n" "${USER}%{${fg_bold[green]}%}@${HOST} %{${fg_bold[blue]}%}${PWD} $(decorate-branch)"
  printf "%s" "%{${reset_color}%}%(!.#.$) "
}

########################################
# プロンプト

# プロンプト文字列に変数の展開が使えるようになる？
setopt prompt_subst

# コピペしやすいようにコマンド実行後は右プロンプトを消す。
setopt transient_rprompt

# プロンプト表示前に実行される？
function precmd ()
{
  PROMPT="$(decorate-prompt)"
}

########################################
# 実行直前に色をリセットする

function preexec ()
{
  printf "%s" ${reset_color}
}

########################################
# run-help

alias run-help > /dev/null 2>&1 && unalias run-help
autoload -Uz run-help run-help-git run-help-openssl run-help-sudo

########################################
# EDITOR

type nvim > /dev/null 2>&1 && export EDITOR=nvim
#export VTE_CJK_WIDTH=1
#export XDG_CONFIG_HOME=${HOME}/.config

#alias vim='printf "vimがいいのですか？でもnvimを起動しますね。" && read -k1 && nvim'

########################################
# PATH

#export PATH="${PATH}:${HOME}/bin"
#export LD_LIBRARY_PATH="${HOME}/lib"

########################################
# 環境依存

case ${OSTYPE} in
  darwin*)
    # ここに Mac 向けの設定
    alias ls='\ls -G'
    ;;
  linux*)
    # ここに Linux 向けの設定
    alias ls='\ls --color=auto -F'
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
    alias open=xdg-open
    ;;
esac

# WSL
if [[ $(uname -r) =~ Microsoft$ ]]
then
  # windows用open
  function win-open ()
  {
    if [[ $# -eq 1 ]]
    then
      cmd.exe /c start $(wslpath -m $(readlink -f "$1"))
    else
      echoerr Error: win-open: 引数を正しく指定してください。
      echoerr "Usage: win-open [file/path]"
      return 1;
    fi
  }

  alias open=win-open

  PATH="${PATH}:/mnt/c/opt/ffmpeg/bin"
  alias java=/mnt/c/Program\\\ Files/Java/jre1.8.0_211/bin/java.exe
fi

########################################
# aliasたち

#alias ls='\ls --color=auto -F'
alias la='ls -A'
alias ll='ls -l -A'
alias grep='\grep --color=auto'

#type xsel > /dev/null 2>&1 && alias pbcopy='xsel --clipboard --input' && alias pbpaste='xsel --clipboard --output'
#type xdg-open > /dev/null 2>&1 && alias open=xdg-open

alias cp='\cp -i'
alias mv='\mv -i'
alias rm='\rm -i'
alias rr='\rm -ri'

alias type='\type -as'

# alias fcrontab='fcrontab -i'

alias history='\history 0'
alias historygrep='\history 0 | grep'

alias addp='\git add -p'
alias gommit='\git commit -v'
alias commit='\git commit -v'
alias checkout='\git checkout'
alias push='\git push'
alias fetch='\git fetch'

#alias git='git-restrict'

alias encrypt='openssl aes-256-cbc -e -salt'
alias decrypt='openssl aes-256-cbc -d -salt'

# set wallpaper
alias wallpaper='feh --no-fehbg --randomize --bg-max'

alias vscode=code

alias nvimrc='${EDITOR} ${HOME}/.config/nvim/init.vim'
alias zshrc='${EDITOR} ${HOME}/.zshrc'
alias relogin='exec zsh -l'

#chinoopt='-std=c++2a -Weverything -Wno-c++98-compat-pedantic -pedantic-errors -O2 -pipe'
#alias chino='clang++ ${=chinoopt}'
alias chino='clang++ -std=c++2a -Weverything -Wno-c++98-compat-pedantic -pedantic-errors -O2 -pipe'

# typo
#alias exho=echo

# alias -g GREP='| grep'
# alias -g SED='| sed'
# alias -g COPY='| pbcopy'

########################################
# compile

alias my-cc='clang -std=c11 -Wall -Wextra -pedantic-errors -O2 -pipe'

#function my-cxx ()
#{
#  clang++ -std=c++1z -Weverything -Wno-c++98-compat -Wno-c++98-compat-pedantic -pedantic-errors -O2 -stdlib=libc++ -I../include -Iinclude "$@" -lc++abi
#}

function my-runc ()
{
  my-cc -o /tmp/a.out "$1" && shift && /tmp/a.out "$@"
}

#function my-runcxx ()
#{
#  my-cxx -o /tmp/a.out "$1" && shift && /tmp/a.out "$@"
#}

function runchino ()
{
  chino -o /tmp/a.out "$1" && shift && /tmp/a.out "$@"
}

# sandbox用(?)
function my-ghc ()
{
  if [[ -e .cabal-sandbox ]]
  then
    ghc -package-db .cabal-sandbox/*.conf.d "$@"
  else
    ghc "$@"
  fi
}

########################################
# utility

# ぐぐる
function google ()
{
  [[ -z $* ]] && set -- `head -1` && open "https://www.google.com/#q=$*"
}

# ほぐる
function hoogle ()
{
  [[ -z $* ]] && set -- `head -1` && open "https://www.haskell.org/hoogle/?hoogle=$*"
}

# /tmp/trash に移動
function trash ()
{
  mkdir -p /tmp/trash && mv -fv "$@" /tmp/trash
}

# stderrへのecho、ついでに終了コード1
function echoerr ()
{
  echo "$@" >&2
  return 1
}

# ♪
function music-play ()
{
  mplayer "$@" || echoerr Error: cannot play.
}

# 拡張子から圧縮形式を判別して解凍
function extract ()
{
  if [[ -z $1 || -n $2 ]]
  then
    \type -f extract >&2
  else
    case "$1" in
      *.tgz | *.tar.gz) tar -zxvf "$1" ;;
      *.tbz2 | *.tar.bz2) tar -jxvf "$1" ;;
      *.tar.xz) tar -Jxvf "$1" ;;
      *.tar) tar -xvf "$1" ;;
      *.gz) gzip -dc "$1" ;;
      *.bz2) bzip2 -dc "$1" ;;
      *.xz) xz -d "$1" ;;
      *.zip) unzip "$1" ;;
      *.rar) unrar x "$1" ;;
      *) echoerr Error: unknown suffix. ;;
    esac
  fi
}

# 拡張子に合った圧縮形式で圧縮
function compress ()
{
  case "$1" in
    *.tgz | *.tar.gz) tar -zcvf "$@" ;;
    *.tbz2 | *.tar.bz2) tar -jcvf "$@" ;;
    *.tar.xz) tar -Jcvf "$@" ;;
    *.tar) tar -cvf "$@" ;;
    *.zip) zip -r "$@" ;;
    *.rar) rar a "$@" ;;
    *) echoerr Error: unknown suffix. ;;
  esac
}

# ~以下のすべてのリポジトリに対してgit statusを実行
# .cacheは除外
function git-status-all ()
{
  local i
  for i in `find ~ -name .cache -type d -prune -o -name .git -type d -exec dirname {} \;`
  do
    printf "%s\n" "$i"
    \git -C "$i" status -s
  done
}

# いらない(と思う)機能を制限したgit
# (git configで対応できたらなぁ…)
function git-restrict ()
{
  case "$1" in
    stash) echoerr "git stash is disabled by .zshrc" ;;
    *) \git "$@" ;;
  esac
}

########################################
# suffix alias

alias -s {mp3,flac,m4a}=music-play
alias -s py=python3
alias -s hs=runhaskell
alias -s c=my-runc
alias -s {cpp,cxx,cc}=runchino
alias -s ml=ocaml
alias -s html=open
alias -s {tgz,tbz2,gz,bz2,xz}=extract
alias -s tar='tar xvf'
alias -s zip='unzip'
alias -s rar='unrar x'
alias -s jar='java -jar'
type wine > /dev/null 2>&1 && alias -s exe='wine'

########################################
# キーバインド

# Emacs風キーバインド
bindkey -e

# Ctrl+arrow key
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# HOME,ENDで移動する
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# Deleteキーで消す
bindkey "^[[3~" delete-char

# Shift+Tabで逆順補完
bindkey "^[[Z" reverse-menu-complete

########################################
# History

export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=12000
export SAVEHIST=12000
setopt EXTENDED_HISTORY

# ヒストリーファイルを共有する
setopt share_history

# 直前と同じコマンドラインは追加しない
setopt hist_ignore_dups

# 戦闘がスペースで始まる場合は追加しない
setopt hist_ignore_space

# 余分な空白を削除して追加
setopt hist_reduce_blanks

########################################
# auto cd , auto pushd , auto ls

# 勝手にcdする
setopt auto_cd

# cd時にpushdする
# popdコマンド全く使ってないし、いらないかな…
#setopt auto_pushd

# 同じディレクトリはpushしない
setopt pushd_ignore_dups

# cdしたときに自動的にls
function chpwd ()
{
  la
}

# 直前にエラーを吐いてもエラーコードを表示しないように、何もしないコマンド。
:

