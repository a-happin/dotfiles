function fzf-process
  ps -ef | sed 1d | fzf --multi | awk '{print $2}'
end
