#------------------------------
# zinit
#------------------------------

typeset -gAH ZINIT
ZINIT[HOME_DIR]=${XDG_CACHE_HOME}/zsh/.zinit
[[ -d ${ZINIT[HOME_DIR]} ]] || {
  mkdir -p ${ZINIT[HOME_DIR]} && git clone --depth 1 https://github.com/zdharma-continuum/zinit.git ${ZINIT[HOME_DIR]}/bin
}
source ${ZINIT[HOME_DIR]}/bin/zinit.zsh

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
setopt auto_cd

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

# コマンドラインだけではなく実行時刻と実行時間も保存する
setopt extended_history

# 直前と同じコマンドラインは追加しない
setopt hist_ignore_dups

# 古いものと同じなら古い方を削除
setopt hist_ignore_all_dups

# 戦闘がスペースで始まる場合は追加しない
setopt hist_ignore_space

# 余分な空白を削除して追加
setopt hist_reduce_blanks

# ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_verify

# historyコマンドは履歴に保存しない
setopt hist_no_store

# 保管時にヒストリを展開
setopt hist_expand

# 即座に履歴ファイルにコマンドを書き込む(zshを複数開いている場合などに有効)
setopt inc_append_history

# ヒストリーファイルを共有する
setopt share_history


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

    if read line
    then
      branch_name="${${line}#* }"
      while IFS= read line
      do
        case "${line[1,2]}" in
          \?\?) ((++untracked)) ;;
          ?\ ) ((++staged)) ;;
          \ ?) ((++modified)) ;;
          *)
            ((++staged))
            ((++modified))
            ;;
        esac
      done
      if [[ ${untracked} -ne 0 ]]
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

# プロンプト表示前に実行される
precmd ()
{
  PROMPT="$(decorate-prompt)"
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
# function chpwd ()
# {
#   la
# }


#------------------------------
# plugin
#------------------------------
type zinit > /dev/null 2>&1 && {
  # iceにblockfを追記すると、プラグインの中で$fpathに書き込むのを禁止（無効化）します。 これはzinitを使うときに有用です。
  # zinitはプラグインの中の補完用のファイルを自動で探索し、シンボリックリンクを使ってfpathに追加する特殊な機能があります。
  # なので、プラグインの中のfpath追加を使わずにzinitに面倒を見させるのほうが高速となります。
  zinit wait lucid light-mode for \
    @zdharma-continuum/fast-syntax-highlighting \
    @zsh-users/zsh-autosuggestions
  zinit wait lucid blockf light-mode for @zsh-users/zsh-completions
  zinit wait lucid null for atinit'source "$ZDOTDIR/.zshrc.lazy"' @zdharma-continuum/null
}


#------------------------------
# startuptime
#------------------------------
type zprof > /dev/null 2>&1 && zprof


#------------------------------
# 直前にエラーを吐いてもエラーコードを表示しないように、何もしないコマンド。
#------------------------------
:
