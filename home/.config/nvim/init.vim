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
" ** speeding up
" *******************************
" 遅くなるんだが
" lua vim.loader.enable ()


" *******************************
" **  source
" *******************************
function! s:source (file) abort
  execute join (['source ', $XDG_CONFIG_HOME, '/nvim/', a:file], '')
endfunction


call s:source ('init/set.vim')
call s:source ('init/plugin.vim')
call s:source ('init/dein.vim')
call s:source ('init/autocmd.vim')
call s:source ('init/command.vim')
" if system ('uname -r') =~? 'microsoft'
" if has ("wsl")
"   call s:source ('init/wsl.lua')
" endif


" *******************************
" **  last on startup
" *******************************
filetype plugin indent on
syntax enable

call s:source ('init/colorscheme.vim')

function! s:defer_setup() abort
  call s:source ('init/mappings.vim')
  call s:source ('init/digraph.vim')
  if has ("wsl")
    call s:source ('init/wsl.lua')
  endif
endfunction


" *******************************
" **  lazy
" *******************************
if has ('vim_starting')
  augroup init-lazy-source
    autocmd!
    autocmd VimEnter * ++once call s:defer_setup()
    autocmd InsertEnter * ++once call s:source ('init/mappings_i.vim')
  augroup END
else
  call s:defer_setup ()
  call s:source ('init/mappings_i.vim')
endif
