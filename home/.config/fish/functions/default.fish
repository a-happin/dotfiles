function default
  for i in $argv
    if test "$i" != ""
      printf "%s\n" $i
      break
    end
  end
end
