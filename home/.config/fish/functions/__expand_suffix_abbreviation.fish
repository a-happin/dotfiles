function __expand_suffix_abbreviation
  if test 0 = (count (commandline -poc))
    for abbr in $suffix_abbreviation
      echo $abbr | read -l word cmd
      if string match -q -- '*.'$word (commandline -t)
        commandline -t -- $cmd' '(commandline -t)
        break
      end
    end
  end
end
