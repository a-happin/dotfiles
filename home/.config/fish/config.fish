################################
# env
################################

if status is-login

  # バグるのでやめといたほうがいい
  # set -gx SHELL (type -P fish)

  type -fq nvim && begin
    set -gx EDITOR nvim
    set -gx VISUAL nvim
  end

  # XDG Base Directory
  set -gx XDG_CONFIG_HOME "$HOME/.config"
  set -gx XDG_CACHE_HOME "$HOME/.cache"
  set -gx XDG_DATA_HOME "$HOME/.local/share"

  set -gx FZF_DEFAULT_COMMAND 'fd --hidden --no-ignore --exclude .git --type f'

  # set i3-sensible-terminal
  set -gx TERMINAL alacritty

  # prepend to $PATH
  set -g fish_user_paths "$HOME/bin"
  set -a fish_user_paths "$HOME/.cargo/bin"
  set -a fish_user_paths "$HOME/.deno/bin"

  # Windows WSL
  if uname -r | string match -q -- '**Microsoft'
    set -a fish_user_paths "$HOME/.nodebrew/current/bin"
    set -a fish_user_paths "$HOME/.fzf/bin"
    set -gx DISPLAY 'localhost:0'

    alias java='java.exe'
    alias explorer='explorer.exe'
    alias ffmpeg='ffmpeg.exe'
    alias ffprobe='ffprobe.exe'
    alias ffplay='ffplay.exe'
    alias open='powershell.exe start'
  end
end

################################
# first initialize
################################

if not set -Uq fish_greeting
  # あいさつはいらない
  set -U fish_greeting

  # use default key bindings
  set -U fish_key_bindings fish_default_key_bindings

  # set colors
  set -U fish_color_autosuggestion 969896
  set -U fish_color_cancel -r
  set -U fish_color_command c397d8
  set -U fish_color_comment e7c547
  set -U fish_color_cwd green
  set -U fish_color_cwd_root red
  set -U fish_color_end c397d8
  set -U fish_color_error d54e53
  set -U fish_color_escape 00a6b2
  set -U fish_color_history_current --bold
  set -U fish_color_host normal
  set -U fish_color_host_remote yellow
  set -U fish_color_match --background=brblue
  set -U fish_color_normal normal
  set -U fish_color_operator 00a6b2
  set -U fish_color_param 7aa6da
  set -U fish_color_quote b9ca4a
  set -U fish_color_redirection 70c0b1
  set -U fish_color_search_match 'bryellow' '--background=brblack'
  set -U fish_color_selection 'white' '--bold' '--background=brblack'
  set -U fish_color_status red
  set -U fish_color_user brgreen
  set -U fish_color_valid_path --underline
  set -U fish_pager_color_completion normal
  set -U fish_pager_color_description 'B3A06D' 'yellow'
  set -U fish_pager_color_prefix 'white' '--bold' '--underline'
  set -U fish_pager_color_progress 'brwhite' '--background=cyan'
end


if status is-interactive

  ################################
  # variable
  ################################


  # PATH以外の配列をexportするとバグり散らかすので仕方なく変数にする
  set -g CHINO_OPT -std=c++2b -Weverything -Wno-c++98-compat-pedantic -Wno-c11-extensions -pedantic-errors -I./include -I. -O2 -pipe


  ################################
  # function
  ################################

  function runchino
    clang++ $CHINO_OPT -o /tmp/a.out $argv[1] && echo -e "\033[1mcompile suceeded.\033[0m" >&2 && /tmp/a.out $argv[2..-1]
  end

  if type -fq exa
    alias ls='exa'
  end


  ################################
  # abbreviation
  ################################
  # abbreviation
  abbr --add -g q 'exit'
  abbr --add -g g 'git'
  abbr --add -g push 'git push'
  abbr --add -g pushu 'git push -u origin HEAD'
  abbr --add -g commit 'git commit -v'
  abbr --add -g e "$EDITOR"

  # default options
  abbr --add -g la 'ls -lah'
  abbr --add -g ll 'ls -lah'
  abbr --add -g exa 'exa -lah'
  abbr --add -g cp 'cp -iv'
  abbr --add -g mv 'mv -iv'
  abbr --add -g rm 'rm -i'
  abbr --add -g rr 'rm -ri'
  abbr --add -g rrf 'rm -rf'
  abbr --add -g ln 'ln -snfv FILE LINK'
  abbr --add -g rmlink 'unlink'
  abbr --add -g mkdir 'mkdir -p'
  abbr --add -g df 'df -h'
  abbr --add -g du 'du -h --max-depth 1'
  abbr --add -g fd 'fd --hidden --no-ignore --exclude .git'
  abbr --add -g rg 'rg --hidden --no-ignore --glob \'!.git\''
  abbr --add -g ssh-keygen 'ssh-keygen -t ed25519 -f ~/.ssh/__DIRECTORY__/id_ed25519 # mkdir before create'
  abbr --add -g rsync 'rsync -avh --progress --delete --dry-run SRC_DIR/ DEST_DIR # Be careful with the \'/\' at the end.'
  abbr --add -g paccache 'paccache -r; paccache -ruk0; yay --aur -Sc'
  abbr --add -g funced 'funced --save'
  abbr --add -g history-delete ' history delete --case-sensitive --exact (history | fzf --multi || printf :)'

  # like a new command
  abbr --add -g note "$EDITOR -c \"cd %:h\" $HOME/Dropbox/note/note.md"
  abbr --add -g fishrc "$EDITOR -c \"cd %:h\" $XDG_CONFIG_HOME/fish/config.fish"
  abbr --add -g nvimrc "$EDITOR -c \"cd %:h\" $XDG_CONFIG_HOME/nvim/init.vim"
  abbr --add -g zshrc "$EDITOR -c \"cd %:h\" $XDG_CONFIG_HOME/zsh/.zshrc"
  abbr --add -g bashrc "$EDITOR -c \"cd %:h\" $HOME/.bashrc"
  abbr --add -g i3config "$EDITOR -c \"cd %:h\" $XDG_CONFIG_HOME/i3/config"
  abbr --add -g gitconfig 'git config --global -e'
  abbr --add -g encrypt 'openssl aes-256-cbc -e -iter 100'
  abbr --add -g decrypt 'openssl aes-256-cbc -d -iter 100'

  # kawaii
  abbr --add -g chino "clang++ $CHINO_OPT"

  # don't forget sudo
  if test $USER != 'root'
    abbr --add -g pacman 'sudo pacman'
    abbr --add -g apt 'sudo apt'
  end

  # typo
  abbr --add -g :q 'exit'
  abbr --add -g vscode code

  # suffix abbreviation
  # sabbr 'ts' 'deno run --allow-all'
  # sabbr 'cpp' 'runchino'
  # sabbr 'jar' 'java -jar'

  # subcommand abbreviation
  context-abbr 'git' 'discard' 'reset --hard HEAD'
  context-abbr 'git' 'clean' 'clean -df'
  context-abbr 'git' 'init' 'init && git commit --allow-empty -m "Initial commit."'
  context-abbr 'git' 'new' 'switch -c'
  context-abbr 'git' 'cv' 'commit -v'
  context-abbr 'git' 'co' 'checkout'
  context-abbr 'git' 'pu' 'push -u origin HEAD'
  context-abbr 'git' 'a' 'add --patch'
  context-abbr 'git' 'aa' 'add --all'
  context-abbr 'git' 's' 'status'
  context-abbr 'git' 'd' 'diff'
  context-abbr 'git' 'f' 'fetch --prune'
  context-abbr --eval 'git' 'sw' 'echo switch (fzf-git-branch)'
  # context-abbr --eval 'git' 'ct' 'echo commit -m (cat ~/.config/git/git-commit-prefix.txt | fzf --reverse --height=10% | awk \'{print $1}\') --edit -v'
  context-abbr --eval 'git' 'fixup' 'echo commit --fixup (fzf-git-commit)'
  context-abbr --eval 'git' 'fomm' 'echo fetch origin (set -l b (fzf-git-branch); echo $b:$b) \# refresh local branch without checkout'
  context-abbr --eval 'git rebase' '-i' 'echo -- -i (fzf-git-commit)'
  context-abbr --eval 'git' 'pr' 'echo pull --rebase origin (git symbolic-ref --short HEAD)'
  context-abbr --eval 'git' '*pick' 'echo cherry-pick (fzf-git-commit)'
  context-abbr --eval 'git **' 'B' 'fzf-git-branch'
  context-abbr --eval 'git **' 'C' 'fzf-git-commit'

  context-abbr --eval 'cd' 'f' 'fzf-directory'
  context-abbr --eval 'cd' 'g' 'fzf-git-repository'

  context-abbr 'sudo' 'e' "$EDITOR"

  # fake command
  context-abbr -C 'compile' '**.cpp' "clang++ $CHINO_OPT"

  context-abbr -C 'run' '**.cpp' 'runchino'
  context-abbr -C 'run' '**.ts' 'deno run (test -e import_map.json && printf \'%s\' \'--import-map=import_map.json\') --allow-all --unstable'
  context-abbr -C 'run' '**.jar' 'java -jar'

  context-abbr -C 'extract' '**.tar.bz2' 'tar -jxvf'
  context-abbr -C 'extract' '**.tar.gz' 'tar -zxvf'
  context-abbr -C 'extract' '**.tar.xz' 'tar -Jxvf'
  context-abbr -C 'extract' '**.tbz2' 'tar -jxvf'
  context-abbr -C 'extract' '**.tgz' 'tar -zxvf'
  context-abbr -C 'extract' '**.tar' 'tar -xvf'
  context-abbr -C 'extract' '**.bz2' 'bzip2 -dc'
  context-abbr -C 'extract' '**.zip' 'unzip'
  context-abbr -C 'extract' '**.rar' 'unrar x'
  context-abbr -C 'extract' '**.gz' 'gzip -dc'
  context-abbr -C 'extract' '**.xz' 'xz -d'

  context-abbr -C 'compress' '**.tar.bz2' 'tar -jcvf'
  context-abbr -C 'compress' '**.tar.gz' 'tar -zcvf'
  context-abbr -C 'compress' '**.tar.xz' 'tar -Jcvf'
  context-abbr -C 'compress' '**.tbz2' 'tar -jcvf'
  context-abbr -C 'compress' '**.tgz' 'tar -zcvf'
  context-abbr -C 'compress' '**.tar' 'tar -cvf'
  context-abbr -C 'compress' '**.zip' 'zip -r'
  context-abbr -C 'compress' '**.rar' 'rar a'

  # global abbreviation
  context-abbr '**' 'G' '| grep'
  context-abbr '**' 'L' '| less'
  context-abbr --eval '**' '!!' 'history | head -1 || printf "!!"'

  ################################
  # dev
  ################################

  bind \ez commandline_test
  function commandline_test
    echo
    echo t = (commandline -t)
    echo tc = (commandline -t -c)
    echo b = (commandline)
    echo p = (commandline -p)
    echo pc = (commandline -pc)
    echo j = (commandline -j)
    echo poc = (commandline -poc | string join ' ')
    echo pc = (commandline -pc)
    commandline -f repaint
  end


  ################################
  # finally
  ################################

  # Start X at login
  if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
      startx -- -keeptty
    end
  end
end
