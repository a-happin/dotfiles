" *******************************
" **  autocmd
" *******************************

" turn off IME when leave insert mode
if executable ('fcitx5-remote')
  augroup resetIME
    autocmd!
    autocmd InsertLeave * silent !fcitx5-remote -c
  augroup END
endif

" auto reload vimrc
augroup auto-reload-vimrc
  autocmd!
  " autocmd BufWritePost init.vim ++nested source ${MYVIMRC}
  autocmd BufWritePost */.config/nvim/*.vim ++nested source $MYVIMRC | redraw | echomsg '*** Reloaded' $MYVIMRC '***'
augroup END

function! s:auto_save () abort
  if &modified && !&readonly && filewritable (expand ('%'))
    update
    doautocmd BufWritePost
  endif
endfunction

function! s:enable_auto_save () abort
  augroup auto_save_buffer
    autocmd! * <buffer>
    autocmd! TextChanged,InsertLeave <buffer> silent call s:auto_save ()
  augroup END
endfunction

augroup auto_save
 autocmd!
 autocmd FileType rust silent call s:enable_auto_save()
 " autocmd TextChanged,InsertLeave *.rs silent call auto_save#save ()
augroup END

augroup auto_mkdir
  autocmd!
  autocmd BufWritePre * call auto_mkdir#mkdir (expand ('<afile>:p:h'), v:cmdbang)
augroup END

augroup reload-file
  autocmd!
  autocmd InsertEnter,WinEnter,FocusGained * checktime
augroup END

" *******************************
" **  terminal
" *******************************
" terminalを改善する
" * 行番号を非表示にする
" * 自動でTERMINALモードに入る
" * ジョブが終了したterminalをbwipeoutする
" interactive shellの場合,
" * 名前をterm://*/[terminal]に書き換える
" * 終了時に即消す
function! s:init_terminal () abort
  setfiletype terminal
  setlocal nonumber norelativenumber
  if mode () =~# 'i'
    call feedkeys("\<Esc>i")
  else
    startinsert
  endif
  augroup terminal-auto-startinsert
    autocmd! * <buffer>
    autocmd BufEnter,WinEnter <buffer> if mode () =~# 'i' | call feedkeys("\<Esc>i") | else | startinsert | endif
    autocmd TermClose <buffer> autocmd! terminal-auto-startinsert * <buffer>
  augroup END
endfunction

augroup fix-terminal
  autocmd!
  autocmd TermOpen term://* call s:init_terminal ()
  " 名前の変更, 変更前のバッファを吹き飛ばす
  autocmd TermOpen term://*/{bash,fish,zsh,sh} file %/[terminal] | bwipeout! #
  autocmd TermClose term://* setlocal bufhidden=wipe
  autocmd TermClose term://*/\[terminal\] bwipeout!
augroup END

" ftdetect/xxx.vimのほうがいいかも
augroup fix-filetype
  autocmd!
  " autocmd BufNewFile,BufReadPost *.fish setfiletype sh
  autocmd BufNewFile,BufReadPost *.mcmeta setfiletype json
augroup END

augroup restore-cursor-pos
  autocmd!
  autocmd BufReadPost * if &filetype !=# 'gitcommit' && 0 < line ("'\"") && line ("'\"") <= line ("$") | execute "normal! g'\"" | endif
augroup END

augroup special-mapping
  autocmd!
  autocmd FileType qf nnoremap <buffer> <CR> <CR>
augroup END

augroup dictionary
  autocmd!
  autocmd FileType * if filereadable ($XDG_CONFIG_HOME . '/nvim/dictionary/' . &filetype . '.dict') | execute 'setlocal dictionary+=' . $XDG_CONFIG_HOME . '/nvim/dictionary/' . &filetype . '.dict' | endif
augroup END

augroup vimrc-incsearch-highlight
  autocmd!
  autocmd CmdlineEnter /,\? set hlsearch
  autocmd CmdlineLeave /,\? set nohlsearch
augroup END

augroup macro-recording
  autocmd!
  autocmd RecordingEnter * nnoremap <nowait> q q
  autocmd RecordingLeave * nunmap q
augroup END

" lualineが描画されるとintroが消えるバグがあるのでlualineの描画を遅らせる
augroup lazy-intro
  autocmd!
  if argc () ==# 0
    autocmd InsertEnter,BufReadPost * ++once lua require 'init/lualine'
  else
    autocmd VimEnter * ++once lua require 'init/lualine'
  endif
augroup END
