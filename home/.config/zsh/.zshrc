# zmodload zsh/zprof

#------------------------------
# zinit
#------------------------------

# typeset -gAH ZINIT
# ZINIT[HOME_DIR]=${XDG_CACHE_HOME}/zsh/.zinit
# [[ -d ${ZINIT[HOME_DIR]} ]] || {
#   mkdir -p ${ZINIT[HOME_DIR]} && git clone --depth 1 https://github.com/zdharma-continuum/zinit.git ${ZINIT[HOME_DIR]}/bin
# }
# source ${ZINIT[HOME_DIR]}/bin/zinit.zsh

#------------------------------
# settings
#------------------------------
# 3秒以上かかった処理は詳細表示
REPORTTIME=2

# 補完候補がウインドウからはみ出るときに尋ねる
LISTMAX=0

# 補完候補など表示する時はその場に表示し、終了時に画面から消す
setopt always_last_prompt

# ディレクトリ名だけでcdする
# setopt auto_cd

# TAB連打で次の候補を選択
setopt auto_menu

# 自動補完される余分なカンマなどを適宜削除してスムーズに入力できるようにする
setopt auto_param_keys

# ディレクトリ名を補完すると、末尾がスラッシュになる。
setopt auto_param_slash

# cd時にpushdする
# popdコマンド全く使ってないし、いらないかな…
#setopt auto_pushd

# ディレクトリ末尾の/を消す
setopt auto_remove_slash

# エイリアスを設定したコマンドでも補完機能を使えるようにする
setopt complete_aliases

# カーソル位置で補完する
setopt complete_in_word

# コマンドのスペルを修正する
setopt correct
# setopt correct_all

# ファイルの種別を識別マーク表示
setopt list_types

# 補完候補をできるだけ詰めて表示する
setopt list_packed

# globを展開しないで候補の一覧から補完する
setopt glob_complete

# 明確なドットの指定なしで.から始まるファイルも補完する
setopt glob_dots

# '#'以降をコメントとみなす
setopt interactive_comments

# Ctrl-dでログアウトしない
setopt ignore_eof

# jobsでプロセスIDも出力する
setopt long_list_jobs

# コマンドライン引数で --prefix=/usr などの=以降でも補完する
setopt magic_equal_subst

# ディレクトリにマッチした場合末尾に'/'をつける
setopt mark_dirs

# ビープ音を鳴らさない
setopt no_beep
setopt no_list_beep


# Ctrl+Sで停止を無効
# stty stop undef

# Ctrl+Qで再開を無効
# stty start undef

# Ctrl+Sとかを使わない設定(?)
setopt no_flow_control

# ログアウト時にバックグラウンドジョブをkillしない
setopt nohup

# 改行コードで終わらない出力もちゃんと出力する
setopt no_promptcr

# バックグラウンドジョブの状態変化を即時報告する
setopt notify

# 数値順にソート(辞書順ではなく)
setopt numeric_glob_sort

# 文字化け対策
setopt print_eight_bit

# 終了コードが0以外の時それを表示
# PROMPTで代用しました
#setopt print_exit_value

# プロンプト文字列に変数の展開が使えるようになる？
setopt prompt_subst

# 同じディレクトリはpushしない
setopt pushd_ignore_dups

# コピペしやすいようにコマンド実行後は右プロンプトを消す。
setopt transient_rprompt

#------------------------------
# history
#------------------------------

# HISTFILE
[[ -d ${XDG_DATA_HOME}/zsh ]] || mkdir -p ${XDG_DATA_HOME}/zsh
HISTFILE=${XDG_DATA_HOME}/zsh/history

# メモリに保持するhistroy
HISTSIZE=1000

# ファイルに保持するhistory
SAVEHIST=100000

# ヒストリに追加したくないもの
# HISTORY_IGNORE='(cd|pwd|ls)'


# NOTE: inc_append_history, inc_append_history_time, share_historyはどれか1つだけ有効にすること

# 即座に履歴ファイルにコマンドを書き込む(zshを複数開いている場合などに有効)
# setopt inc_append_history

# 即座(?)に履歴ファイルにコマンドを書き込む(zshを複数開いている場合などに有効) +経過時間も正しく書き込む
# inc_append_historyやshare_historyとは一緒にできない
setopt inc_append_history_time

# ヒストリーファイルを共有する
# inc_append_historyと一緒にするとよくない(？)
# setopt share_history

# コマンドラインだけではなく実行開始時刻と実行時間(経過秒数)も保存する
# ※ inc_append_historyがONになっていると経過秒数はすべて0になる
setopt extended_history

# 直前と同じコマンドラインは追加しない
setopt hist_ignore_dups

# 古いものと同じなら古い方を削除
setopt hist_ignore_all_dups

# 履歴がいっぱいになると重複から優先的に削除
setopt hist_expire_dups_first

# ヒストリIO時にロックする？(パフォーマンスが向上するらしい)
setopt hist_fcntl_lock

# ラインエディタでヒストリ検索するときに、一度見つかったものは後続で表示しない
setopt hist_find_no_dups

# 戦闘がスペースで始まる場合は追加しない
setopt hist_ignore_space

# 余分な空白を削除して追加
setopt hist_reduce_blanks

# ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_verify

# historyコマンドは履歴に保存しない
setopt hist_no_store

# 関数定義をヒストリに保存しない
setopt hist_no_functions

# 保管時にヒストリを展開
setopt hist_expand

# ヒストリエディタでスクロールができないときにbeep音を鳴らさない
setopt no_hist_beep


#------------------------------
# prompt
#------------------------------
decorate-branch ()
{
  \git status --porcelain --branch 2> /dev/null | {
    local line
    local branch_name
    local untracked=0
    local staged=0
    local modified=0
    local conflicted=0

    if read line
    then
      branch_name="${${line}#* }"
      while IFS= read line
      do
        case "${line[1,2]}" in
          \?\?) untracked=$((untracked + 1)) ;;
          ?U) conflicted=$((conflicted + 1)) ;;
          ?\ ) staged=$((staged + 1)) ;;
          \ ?) modified=$((modified + 1)) ;;
          *)
            staged=$((staged + 1))
            modified=$((modified + 1))
            ;;
        esac
      done
      if [[ ${untracked} -ne 0 || ${conflicted} -ne 0 ]]
      then
        printf '%%{\e[01;31m%%} (%s)' "${branch_name}"
      elif [[ ${staged} -ne 0 || ${modified} -ne 0 ]]
      then
        printf '%%{\e[01;33m%%} (%s)' "${branch_name}"
      else
        printf '%%{\e[01;36m%%} (%s)' "${branch_name}"
      fi
      [[ ${staged} -ne 0 ]] && printf '%%{\e[01;32m%%} %d staged' "${staged}"
      [[ ${modified} -ne 0 ]] && printf '%%{\e[01;33m%%} %d modified' "${modified}"
      [[ ${untracked} -ne 0 ]] && printf '%%{\e[01;31m%%} %d untracked' "${untracked}"
      [[ ${conflicted} -ne 0 ]] && printf '%%{\e[01;35m%%} %d conflicted' "${conflicted}"
    fi
  }
}

decorate-prompt ()
{
  readonly local exit_code=$?
  printf '%%{\e[00m%%}'
  case "${USER}" in
    root) printf '%%{\e[01;31m%%}%s' "${USER}" ;;
    *) printf '%%{\e[01;32m%%}%s' "${USER}" ;;
  esac
  printf '%%{\e[01;32m%%}%s%%{\e[01;34m%%} %s%s\n' "@${HOST}" '%~' "$(decorate-branch)"
  if [[ ${exit_code} -eq 0 ]]
  then
    printf '%%{\e[01;32m%%}'
  else
    printf '%%{\e[01;31m%%}%s ' "${exit_code}"
  fi
  printf "%s" "%(!.#.>) "
  printf '%%{\e[00m%%}'
}

decorate-prompt2::sep ()
{
  printf ' %%{\e[0;1;3%s;10%sm%%}\ue0b0%%{\e[0;1;7;3%sm%%} ' "${__decorate_prompt2_current}" "${1}" "${1}"
  __decorate_prompt2_current=$1
}


decorate-prompt2::git ()
{
  \git status --porcelain --branch 2> /dev/null | {
    local line
    local branch_name
    local untracked=0
    local staged=0
    local modified=0
    local conflicted=0

    if read line
    then
      branch_name="${${line}#* }"
      while IFS= read line
      do
        case "${line[1,2]}" in
          \?\?) untracked=$((untracked + 1)) ;;
          ?U) conflicted=$((conflicted + 1)) ;;
          ?\ ) staged=$((staged + 1)) ;;
          \ ?) modified=$((modified + 1)) ;;
          *)
            staged=$((staged + 1))
            modified=$((modified + 1))
            ;;
        esac
      done

      # segment: branch
      decorate-prompt2::sep 6
      printf "%s" "${branch_name}"

      [[ ${staged} -ne 0 ]] && decorate-prompt2::sep 2 && printf '%d staged' "${staged}"
      [[ ${modified} -ne 0 ]] && decorate-prompt2::sep 3 && printf '%d modified' "${modified}"
      [[ ${untracked} -ne 0 ]] && decorate-prompt2::sep 1 && printf '%d untracked' "${untracked}"
      [[ ${conflicted} -ne 0 ]] && decorate-prompt2::sep 5 && printf '%d conflicted' "${conflicted}"
    fi
  }
}

decorate-prompt2 ()
{
  readonly local exit_code=$?
  # begin of line
  printf "%%{\e[0;1;32m%%}\ue0b6%%{\e[7m%%}"
  __decorate_prompt2_current=2
  # printf '%%{\e[0;7m%%}'
  # case "${USER}" in
  #   root) printf '%%{\e[01;31m%%}%s' "${USER}" ;;
  #   *) printf '%%{\e[01;32m%%}%s' "${USER}" ;;
  # esac
  # segment: user@host
  printf "%s@%s" "${USER}" "${HOST}"

  decorate-prompt2::sep 4

  # segnemt: pwd
  printf "%s" "%~"
  # printf '%%{\e[01;32m%%}%s%%{\e[01;34m%%} %s%s\ue0b5\n' "@${HOST}" '%~' "$(decorate-branch)"

  #segment: git
  decorate-prompt2::git

  # end of line
  # printf "%%{\e[0;1;3%sm%%}\ue0b4\n" "${__decorate_prompt2_current}"
  printf "%%{\e[27m%%}\ue0b4\n"

  if [[ ${exit_code} -eq 0 ]]
  then
    printf '%%{\e[0;1;32m%%}'
  else
    printf '%%{\e[0;1;31m%%}%s ' "${exit_code}"
  fi
  printf "%s" "%(!.#.>) "
  printf '%%{\e[00m%%}'
}

# プロンプト表示前に実行される
precmd ()
{
  PROMPT="$(decorate-prompt2)"
  # RPROMPT='[zsh]'
}


#------------------------------
# 実行直前に色をリセットする
#------------------------------
preexec ()
{
  printf '\e[00m'
}

#------------------------------
# cdしたときに自動的にls
#------------------------------
# chpwd ()
# {
#   la
# }

# zsh in nvimのとき、cdしたらlcdもする
[[ -n $NVIM ]] && chpwd ()
{
  command nvim --server $NVIM --remote-send "<Cmd>lcd ${PWD}<CR>"
}

#------------------------------
# zshaddhistory
#------------------------------
# ヒストリ追加直前(コマンド実行前)に呼ばれる
# この関数が失敗(0以外)を返すとヒストリに追加されない
# 0: 追加される
# 1: ヒストリにもメモリにも追加されない
# 2: メモリには追加される(fc -lで確認できる)が、ヒストリには追加されない
zshaddhistory ()
{
  # 複数コマンドはヒストリに追加する
  # 単純すぎるコマンドはヒストリに追加しない
  local line="${1%$'\n'}"
  case "$line" in
    '') return 1 ;;
    \ *) return 1 ;;
    *\;*) return 0 ;;
    *\&*) return 0 ;;
    *\|*) return 0 ;;
    *\(*) return 0 ;;
    *\`*) return 0 ;;
    *$'\n'*) return 0 ;;
    *\<*) return 0 ;;
    *\>*) return 0 ;;
  esac

  case "$line" in
    :) return 1 ;;
    nvim) return 2 ;;
    git\ add\ *) return 2 ;;
  esac

  # 単純かつ副作用のないコマンドは追加しない
  local cmd="${line%% *}"
  case "$cmd" in
    '') return 1 ;;
    *=*) return 0 ;; # 変数定義かも
    ls) return 2 ;;
    pwd) return 1 ;;
    history) return 2 ;;
    type) return 2 ;;
    echo) return 2 ;;
    man) return 2 ;;
    run-help) return 1 ;;
    cat) return 2 ;;
    bat) return 2 ;;
    cal) return 2 ;;
    date) return 2 ;;
    notify-send) return 2 ;;
  esac

  # typeの結果をそのまま返す
  # 存在しないコマンドは追加しない
  \type "$cmd" > /dev/null 2>&1
}


#------------------------------
# lazy
#------------------------------
# https://github.com/romkatv/zsh-defer の簡易版
typeset -ga __lazy_tasks
function __lazy_resume ()
{
  # stop subscribing file descripter
  zle -F $1
  # close file descripter
  exec {1}>&-

  while (( $#__lazy_tasks ))
  do
    __lazy_apply ${__lazy_tasks[1]}
    shift __lazy_tasks
  done
  return 0
}
zle -N __lazy_resume
function __lazy_schedule ()
{
  local fd

  # create a new file descripter
  exec {fd}</dev/null

  # subscribe file descripter
  zle -F $fd __lazy_resume
}
function __lazy_apply ()
{
  # echo eval ${(@Q)${(z)1}}
  eval "${(@Q)${(z)1}}"
}
function lazy ()
{
  (( $#__lazy_tasks )) || __lazy_schedule
  __lazy_tasks+="${(@q)@}"
}


#------------------------------
# plugin
#------------------------------
# type zinit > /dev/null 2>&1 && {
  # zinit wait lucid light-mode for \
    # @zdharma-continuum/fast-syntax-highlighting
  # iceにblockfを追記すると、プラグインの中で$fpathに書き込むのを禁止（無効化）します。 これはzinitを使うときに有用です。
  # zinitはプラグインの中の補完用のファイルを自動で探索し、シンボリックリンクを使ってfpathに追加する特殊な機能があります。
  # なので、プラグインの中のfpath追加を使わずにzinitに面倒を見させるのほうが高速となります。
  # zinit wait lucid blockf light-mode for @zsh-users/zsh-completions
  # zinit wait lucid null for atinit'source "$ZDOTDIR/.zshrc.lazy"' @zdharma-continuum/null
# }

type git > /dev/null 2>&1 && {

  my_install_plugin ()
  {
    [[ -d "${XDG_CACHE_HOME}/zsh/plugins/${1}" ]] || git clone --depth 1 --recurse-submodules --shallow-submodule "https://github.com/${1}" "${XDG_CACHE_HOME}/zsh/plugins/${1}"
  }

  my_install_plugin "zdharma-continuum/fast-syntax-highlighting" && \
    lazy source "${XDG_CACHE_HOME}/zsh/plugins/zdharma-continuum/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

  my_install_plugin "zsh-users/zsh-autosuggestions" && {
    lazy source "${XDG_CACHE_HOME}/zsh/plugins/zsh-users/zsh-autosuggestions/zsh-autosuggestions.zsh"
    lazy 'ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(history-beginning-search-forward-end history-beginning-search-backward-end); ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=(__lazy_resume)'
  }
}

lazy source "$ZDOTDIR/.zshrc.lazy"

#------------------------------
# startuptime
#------------------------------
type zprof > /dev/null 2>&1 && zprof


#------------------------------
# 直前にエラーを吐いてもエラーコードを表示しないように、何もしないコマンド。
#------------------------------
:
