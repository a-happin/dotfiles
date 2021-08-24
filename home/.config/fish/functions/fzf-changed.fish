function fzf-changed
  git diff --name-only | fzf --multi --preview 'git diff --color=always {}'
end
