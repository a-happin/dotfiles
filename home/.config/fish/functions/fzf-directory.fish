function fzf-directory --wraps=fd
  fd --type d --hidden --follow --no-ignore --exclude .git $argv | fzf --preview 'exa -lha --time-style long-iso --color=always {}'
end
