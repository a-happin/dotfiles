scriptencoding utf-8

" *******************************
" **  autocmd
" *******************************

" turn off IME when leave insert mode
if executable ('fcitx-remote')
  augroup resetIME
    autocmd!
    autocmd InsertLeave * silent !fcitx-remote -c
  augroup END
endif

" auto reload vimrc
augroup auto-reload-vimrc
  autocmd!
  " autocmd BufWritePost init.vim ++nested source ${MYVIMRC}
  autocmd BufWritePost */.config/nvim/*.vim ++nested source $MYVIMRC | redraw | echomsg '*** Reloaded' $MYVIMRC '***'
augroup END

"augroup auto_save
"  autocmd!
"  autocmd TextChanged,InsertLeave * silent call auto_save#save ()
"augroup END

augroup auto_mkdir
  autocmd!
  autocmd BufWritePre * call auto_mkdir#mkdir (expand ('<afile>:p:h'), v:cmdbang)
augroup END

augroup reload-file
  autocmd!
  autocmd InsertEnter,WinEnter,FocusGained * checktime
augroup END

" terminalを改善する
" * 隠れたらbdelete!
" interactive shellの場合,
" * 名前をterm://*://Terminalに書き換える
" * 自動で挿入モードに入る
" * 終了時に即消す
augroup fix-terminal
  autocmd!
  autocmd TermOpen term://* setlocal nonumber bufhidden=delete
  autocmd TermOpen term://*/bash,term://*/fish,term://*/zsh file %://Terminal | startinsert
  autocmd WinEnter term://*://Terminal startinsert
  autocmd TermClose term://*://Terminal bdelete!
augroup END

" ftdetect/xxx.vimのほうがいいかも
augroup fix-filetype
  autocmd!
  " autocmd BufNewFile,BufReadPost *.fish setfiletype sh
  autocmd BufNewFile,BufReadPost *.mcmeta setfiletype json
augroup END

augroup restore-cursor-pos
  autocmd!
  autocmd BufReadPost * if &filetype !=# 'gitcommit' && line ("'\"") > 0 && line ("'\"") <= line ("$") | execute "normal! g'\"" | endif
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
