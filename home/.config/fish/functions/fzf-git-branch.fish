function fzf-git-branch
  git branch --all | cut -c 3- | fzf --reverse -0 --height 60%
end
