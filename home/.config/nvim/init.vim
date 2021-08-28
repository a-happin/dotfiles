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

" *******************************
" **  source
" *******************************

function! s:source (file) abort
  execute 'source ' . $XDG_CONFIG_HOME . '/nvim/' . a:file
endfunction

call s:source ('init/set.vim')
call s:source ('init/command.vim')
call s:source ('init/plugin.vim')
call s:source ('init/mappings.vim')
call s:source ('init/autocmd.vim')

filetype plugin indent on
syntax enable

call s:source ('init/colorscheme.vim')

augroup lazy-source
  autocmd!
  autocmd InsertEnter * ++once call s:source ('init/mappings_i.vim')
augroup END
