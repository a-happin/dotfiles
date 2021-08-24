function mkdircd --description 'mkdir and cd'
  mkdir -p $argv[1] && cd $argv[1]
end
