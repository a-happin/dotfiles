function fish_prompt --description 'Write out the prompt'
  set -l last_status $status
  set -g fish_prompt_pwd_dir_length 0
  # set_color --reverse --bold
  if test "$USER" = 'root'
    set_color --bold brred
  else
    set_color --bold brgreen
  end
  printf '%s@%s %s' $USER(set_color brgreen) (prompt_hostname) (set_color brblue)(prompt_pwd)
  printf ' %s\n' (git_prompt)
  # printf '%s %s %s\n' (set_color --reverse brgreen)$USER'@'(prompt_hostname)' '(set_color brblue)(prompt_pwd) (git_prompt)
  set_color normal
  if test "$last_status" -eq 0
    set_color --bold brgreen
  else
    set_color --bold brred
    printf '%s ' $last_status
  end
  if test $USER = 'root'
    printf '# '
  else
    printf '> '
  end
  set_color normal
end

# function fish_mode_prompt
# end

function git_prompt --description 'Write out git branch for prompt'
  git status --porcelain --branch 2> /dev/null | begin
    if read -l line
    set -l branch_name
    set -l untracked
    set -l staged
    set -l modified
      set branch_name (string sub -s 4 $line)
      while read -l --line line
        switch (string sub -l 2 $line)
          case '\?\?'
            set untracked $untracked 1
          case '? '
            set staged $staged 1
          case ' ?'
            set modified $modified 1
          case '*'
            set staged $staged 1
            set modified $modified 1
        end
      end
      if test (count $untracked) -ne 0
        set_color brred
      else if test (count $staged $modified) -ne 0
        set_color bryellow
      else
        set_color brcyan
      end
      printf '(%s)' $branch_name
      test (count $staged) -ne 0 && printf '%s %d staged' (set_color brgreen) (count $staged)
      test (count $modified) -ne 0 && printf '%s %d modified' (set_color bryellow) (count $modified)
      test (count $untracked) -ne 0 && printf '%s %d untracked' (set_color brred) (count $untracked)
    end
  end
end
