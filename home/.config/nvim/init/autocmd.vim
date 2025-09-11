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
  autocmd BufWritePost */.config/nvim/*.vim ++nested source $MYVIMRC | redraw | lua vim.notify (string.format ('*** Auto Reload ***\n%s', vim.env.MYVIMRC), nil, {title = 'Auto Reload init.vim'})
augroup END

augroup auto_lcd
  autocmd!
  autocmd BufReadPost */.config/nvim/* lcd ~/.config/nvim
  autocmd BufReadPost */.config/zsh/* lcd ~/.config/zsh
  autocmd BufReadPost */.config/fish/* lcd ~/.config/fish
  autocmd BufReadPost */.config/i3/* lcd ~/.config/i3
augroup END

" ファイル保存時のハッシュ値と同じだったらmodifiedフラグをresetする
" 衝突した場合？知らん
" BufReadPost: ファイルを読み込んだあと
" BufModifiedSet: ファイルを書き込んだあと(更新)
" BufNewFile: 存在しないファイルを開いた(新規ファイル) ただしファイル名が空のときは呼ばれない
" BufAdd {}: 新規ファイル ファイル名が空 ただし VimEnter前は呼ばれない
" lua table.concat (vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n") -- bufnrは0でいい
" augroup check_hash
"   autocmd!
"   autocmd BufReadPost,BufModifiedSet ?* if &modifiable && !&readonly && !&modified | let b:my_hash = sha256 (join (getline (1, '$'), '\n')) | endif
"   autocmd TextChanged,InsertLeave * if &modifiable && !&readonly && &modified && sha256 (join (getline (1, '$'), '\n')) ==# get (b:, 'my_hash', 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855') | setlocal nomodified | endif
" augroup END
lua require'my_lib/auto_unset_modified'

function! s:auto_save () abort
  if &modified && !&readonly && &buftype ==# '' && filewritable (expand ('%'))
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
 " autocmd FileType rust silent call s:enable_auto_save()
 " autocmd TextChanged,InsertLeave *.rs silent call auto_save#save ()
augroup END

augroup auto_mkdir
  autocmd!
  autocmd BufWritePre * call auto_mkdir#mkdir (expand ('<afile>:p:h'), v:cmdbang)
augroup END

" たしか外部での変更を検知する設定
" set autoread だけじゃだめなのか…
augroup reload-file
  autocmd!
  autocmd InsertEnter,WinEnter,FocusGained * checktime %
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
  " autocmd TermOpen term://*/{bash,fish,zsh,sh} file %/[terminal] | bwipeout! #

  " 両方コメントアウトしてもwipeoutされてそー
  " autocmd TermClose term://* setlocal bufhidden=wipe
  " 上の定義と2重に実行されてバッファが2つ消えるため、片方をコメントアウトして様子見
  " autocmd TermClose term://*/\[terminal\] bwipeout!
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
  autocmd FileType help nnoremap <buffer> <C-CR> <C-]> | nnoremap <buffer> <Space><CR> <C-]>
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

" qfが定義されていると何故か機能しないけど、q:だけなら機能する(??)
augroup macro-recording
  autocmd!
  autocmd RecordingEnter * nnoremap <nowait> q q
  autocmd RecordingLeave * nunmap q
augroup END

" lualineが描画されるとintroが消えるバグがあるのでlualineの描画を遅らせる
" https://github.com/nvim-lualine/lualine.nvim/issues/773
if has ('vim_starting')
  augroup lazy-lualine
    autocmd!
    autocmd InsertEnter,BufReadPost,CmdlineLeave * ++once autocmd! lazy-lualine | lua require 'init/lualine'
  augroup END
else
  lua require 'init/lualine'
endif
