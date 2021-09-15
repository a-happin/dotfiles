function fzf-directory
  fd --type d --hidden --follow --no-ignore --exclude .git | fzf --preview 'exa -lha --time-style long-iso --color=always {}'
end
