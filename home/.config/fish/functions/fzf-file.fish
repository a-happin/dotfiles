function fzf-file
  fd --type f --hidden --follow --exclude .git | fzf --ansi --preview 'bat --color=always --style=numbers --line-range :500 {}'
end
