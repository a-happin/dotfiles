scriptencoding utf-8

function! pack#init () abort
  " ********************************
  " * minpac
  " ********************************
  call pack#minpac#init ()
  packadd minpac
  call minpac#init ()

  " plugin manager (required)
  call minpac#add ('k-takata/minpac', {'type': 'opt'})

  " LSP client
  call minpac#add ('neoclide/coc.nvim', {'type': 'opt', 'branch': 'release'})

  " show git diff at SignColumn
  call minpac#add ('airblade/vim-gitgutter', {'type': 'opt'})

  " customize statusline
  call minpac#add ('itchyny/lightline.vim', {'type': 'opt'})

  " lightlineにcoc情報を表示する関数を提供する
  call minpac#add ('josa42/vim-lightline-coc', {'type': 'opt'})

  " toggle comment
  call minpac#add ('tpope/vim-commentary', {'type': 'opt'})

  " fzf
  call minpac#add ('junegunn/fzf.vim', {'type': 'opt'})

  " fern
  call minpac#add ('lambdalisue/fern.vim', {'type': 'opt'})

  " color codeを色で表示
  call minpac#add ('gorodinskiy/vim-coloresque', {'type': 'opt'})

  " C++
  call minpac#add ('octol/vim-cpp-enhanced-highlight', {'type': 'opt'})

  " fish shell script
  call minpac#add ('dag/vim-fish', {'type': 'opt'})
endfunction

function! pack#VimEnter (...) abort
  " ********************************
  " * vim-commentary
  " ********************************
  packadd vim-commentary

  " ********************************
  " * lightline
  " ********************************
  call pack#lightline#init ()
  packadd vim-lightline-coc
  call lightline#coc#register ()
  packadd lightline.vim
  call lightline#update ()

  " ********************************
  " * vim-gitgutter
  " ********************************
  packadd vim-gitgutter

  " ********************************
  " * coc.nvim
  " ********************************
  call pack#coc#init ()
  packadd coc.nvim
endfunction

function! pack#CmdUndefined (cmd) abort
  " ********************************
  " * fzf.vim
  " ********************************
  if a:cmd ==# 'Files' || a:cmd ==# 'GFiles' || a:cmd ==# 'Buffers' || a:cmd ==# 'History'
    packadd fzf.vim

  " ********************************
  " * fern.vim
  " ********************************
  elseif a:cmd ==# 'Fern'
    let g:fern#default_hidden=1
    packadd fern.vim
  endif
endfunction

function! pack#BufReadPost (suffix) abort
endfunction

function! pack#FileType (ft) abort
  if a:ft ==# 'cpp'
    packadd vim-cpp-enhanced-highlight
  endif
endfunction

function! pack#InsertEnter () abort
  call init#source ('init/mappings_i.vim')
endfunction
