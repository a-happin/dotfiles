function fzf-directory
  fd --type d --hidden --follow --exclude .git | fzf --preview 'exa -lha --time-style long-iso --color=always {}'
end
