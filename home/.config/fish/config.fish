set -gx SHELL (type -P fish)
set -gx EDITOR nvim
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gxa PATH "$HOME/bin"

set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'

fish_default_key_bindings

# あいさつはいらない
set -g fish_greeting

# ディレクトリ名を省略しない
set -g fish_prompt_pwd_dir_length 0

function relogin
  exec fish
end

function subsh
# 指定した文字列を毎回コマンドライン先頭に挿入するようにする関数

    set -l sub "$argv"

    # --inherit-variable でフック定義時の値をキャプチャ
    function __subsh_hook -e fish_postexec --inherit-variable sub
        if test -n "$sub" -a -n "$argv"
            commandline "$sub "
        else
            # 空エンターあるいは引数なしの`subsh`で終了
            functions -e __subsh_hook
        end
    end
end

function default
  for i in $argv
    if test "$i" != ""
      printf "%s\n" $i
      break
    end
  end
end

function mkdircd
  mkdir -p $argv[1] && cd $argv[1]
end

function trash
  mkdir -p /tmp/trash
  mv -fv $argv /tmp/trash
end

function wallpaper
  feh --no-fehbg --randomize --bg-max $argv
end

function pbcopy
  xsel --clipboard --input
end

function pbpaste
  xsel --clipboard --output
end

function encrypt
  openssl aes-256-cbc -e -iter 100 $argv
end

function decrypt
  openssl aes-256-cbc -d -iter 100 $argv
end

function chino
  clang++ -std=c++20 -Weverything -Wno-c++98-compat-pedantic -pedantic-errors -I./include -O2 -pipe $argv
end

function runchino
  chino -o /tmp/a.out $argv[1] && echo -e "\033[1mcompile suceeded.\033[0m" >&2 && /tmp/a.out $argv[2..-1]
end

function git-status-all
  find ~ -name .cache -prune -o -name .git -type d -exec dirname {} \; | while read -l i
    printf "%s\n" $i
    command git -C "$i" status -s
  end
end

function fishrc
  $EDITOR $XDG_CONFIG_HOME/fish/config.fish
end

function nvimrc
  $EDITOR $XDG_CONFIG_HOME/nvim/init.vim
end

function zshrc
  $EDITOR $HOME/.zshrc
end

function fzf-file
  fd --type f --hidden --follow --exclude .git | fzf --ansi --preview 'bat --color=always --line-range :500 {}'
end

function fzf-directory
  fd --type d --hidden --follow | fzf --preview 'exa -lha --time-style long-iso --color=always {}'
end

function fzf-changed
  git diff --name-only | fzf --multi --preview 'git diff --color=always {}'
end

function fzf-process
  ps -ef | sed 1d | fzf --multi | awk '{print $2}'
end

function fzf-git-repository
  fd --type d --hidden --follow '^.git$' ~ -x dirname | fzf --multi --preview 'git -c color.status=always -C {} status'
end

abbr --add -g 'g' 'git'
abbr --add -g ':q' 'exit'
abbr --add -g 'cp' 'cp -i'
abbr --add -g 'mv' 'mv -i'
abbr --add -g 'rm' 'rm -i'
abbr --add -g 'rr' 'rm -ri'
abbr --add -g 'vscode' 'code'

# suffix abbreviation
sabbr 'ts' 'deno run --allow-all'
sabbr 'cpp' 'runchino'
sabbr 'jar' 'java -jar'
