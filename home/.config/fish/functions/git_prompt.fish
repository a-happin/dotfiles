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
