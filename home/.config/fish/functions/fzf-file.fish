function fzf-file
  # fd --type f --hidden --follow --no-ignore --exclude .git | fzf --preview 'bat --color=always --style=numbers --line-range :500 {}'
  fzf --preview 'bat --color=always --style=numbers --line-range :500 {}'
end
