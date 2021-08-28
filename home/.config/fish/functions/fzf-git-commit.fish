function fzf-git-commit --description 'select git commit by fzf'
  git log --graph --all --oneline --color=always | fzf --ansi --no-sort --reverse --tiebreak index --height=60% --preview "git show --color=always \$(echo -- \"{}\" | grep -io '[0-9a-f]\{7,\}' | head -1)" | grep -io '[0-9a-f]\{7,\}' | head -1
end
