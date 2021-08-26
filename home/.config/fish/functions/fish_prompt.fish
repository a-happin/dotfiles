function fish_prompt --description 'Write out the prompt'
  set -l last_status $status
  # set_color --reverse --bold
  if test "$USER" = 'root'
    set_color --bold brred
  else
    set_color --bold brgreen
  end
  printf '%s@%s %s' $USER(set_color brgreen) (prompt_hostname) (set_color brblue)(prompt_pwd)
  printf ' %s' (git_prompt)
  printf '\n'
  # printf '%s %s %s\n' (set_color --reverse brgreen)$USER'@'(prompt_hostname)' '(set_color brblue)(prompt_pwd) (git_prompt)
  set_color normal
  if test "$last_status" -eq 0
    set_color --bold brgreen
  else
    set_color --bold brred
    printf '%s ' $last_status
  end
  if test $USER = 'root'
    printf '# '
  else
    printf '> '
  end
  set_color normal
end
