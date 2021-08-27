set encoding=utf-8
scriptencoding utf-8


" *******************************
" **  env
" *******************************

if empty ($XDG_CONFIG_HOME)
  let $XDG_CONFIG_HOME = $HOME . '/.config'
endif

if empty ($XDG_CACHE_HOME)
  let $XDG_CACHE_HOME = $HOME . '/.cache'
endif

if empty ($XDG_DATA_HOME)
  let $XDG_DATA_HOME = $HOME . '/.local/share'
endif



call init#source ('init/set.vim')
call init#source ('init/command.vim')
call init#source ('init/plugin.vim')
call init#source ('init/mappings.vim')
call init#source ('init/autocmd.vim')

filetype plugin indent on
syntax enable

call init#source ('init/colorscheme.vim')
