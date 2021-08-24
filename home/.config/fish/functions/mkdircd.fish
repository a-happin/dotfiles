function mkdircd --description 'mkdir and cd'
  mkdir -p $argv && cd $argv[-1]
end
