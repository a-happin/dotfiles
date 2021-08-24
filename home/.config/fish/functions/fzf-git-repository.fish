function fzf-git-repository
  fd --type d --hidden --follow '^.git$' ~ -x dirname | fzf --multi --preview 'git -c color.status=always -C {} status'
end
