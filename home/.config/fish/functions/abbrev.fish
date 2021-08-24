function abbrev --description 'manage abbreviation'
  set -l opts
  set -l args
  set -l end_option 0
  set -l error_flag 0

  # parse argv
  while set -q argv[1]

    # after '--'
    if test $end_option = 1
      set -a args $argv[1..-1]
      break
    end

    switch $argv[1]
      case '--'
        set end_option 1

      case -h --help
        string trim "
abbrev - manage abbreviations

	abbrev --add [SCOPE] [TYPE] [CONTEXT] WORD EXPANSION
	abbrev --erase [TYPE] [CONTEXT] WORD
	abbrev --show
	abbrev --list
	abbrev --query
        "
        return

      case -v --version
        printf '%s\n' 'abbrev v0.1-dev'
        return

      case -{a,g,U,e,s,l,q,C,S,A,F,G,c} --{add,global,universal,erase,show,list,query,context} --abbrev-{command,subcommand,associated-command,fake-command,global,global-context}
        set -a opts $argv[1]

      case '-*'
        set_color --bold brred
        echo abbrev: unknown option -- "$argv[1]" >&2
        set_color normal
        set error_flag 1

      case '*'
        set -a args $argv[1]
    end

    # erase 1
    set -e argv[1]
  end

  # exit if contains unknown option
  if test $error_flag = 1
    return $error_flag
  end

  # check option conflict


  echo opts: (count $opts)
  echo -- $opts
  echo args:
  echo -- $args
end
