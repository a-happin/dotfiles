function fzf-file --wraps=fd
  fd --type f --hidden --follow --no-ignore --exclude .git $argv | fzf --preview 'bat --color=always --style=numbers --line-range :500 {}'
end
