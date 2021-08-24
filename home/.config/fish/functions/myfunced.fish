function myfunced --description 'Edit user defined functions'
  set -l funcs
  if test -e /tmp/functions.fish
    rm -rf /tmp/functions.fish
  end
  for i in $XDG_CONFIG_HOME/fish/functions/*.fish
    cat $i >> /tmp/functions.fish
    echo >> /tmp/functions.fish
    set -a funcs (basename $i .fish)
  end
  $EDITOR /tmp/functions.fish && source /tmp/functions.fish
  set -l res $status
  for i in $funcs
    funcsave $i
  end
  return $res
end
