function git-status-all --description 'Show all git repository'
  find ~ -name .cache -prune -o -name .git -type d -exec dirname {} \; | while read -l i
    printf "%s\n" $i
    command git -C "$i" status -s
  end
end
