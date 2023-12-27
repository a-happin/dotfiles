set encoding=utf-8

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
  execute 'source' $XDG_CONFIG_HOME . '/nvim/' . a:file
endfunction

lua vim.loader.enable ()

call s:source ('init/set.vim')
call s:source ('init/command.vim')
call s:source ('init/plugin.vim')
call s:source ('init/dein.vim')
call s:source ('init/autocmd.vim')
if system ('uname -r') =~? 'microsoft'
  call s:source ('init/wsl.vim')
endif

" *******************************
" **  last on startup
" *******************************
filetype plugin indent on
syntax enable

call s:source ('init/colorscheme.vim')


" *******************************
" **  lazy
" *******************************
if has ('vim_starting')
  augroup init-lazy-source
    autocmd!
    autocmd VimEnter * ++once call s:source ('init/mappings.vim') | call s:source ('init/digraph.vim')
    autocmd InsertEnter * ++once call s:source ('init/mappings_i.vim')
  augroup END
else
  call s:source ('init/mappings.vim')
  call s:source ('init/mappings_i.vim')
  call s:source ('init/digraph.vim')
endif
