scriptencoding utf-8

" ここに書かないと機能しない？
" init.vimに書いてると/usr/share/nvim/runtime/ftplugin/* に普通に上書きされる

augroup set-force
  autocmd!
  autocmd Filetype * setlocal formatoptions& formatoptions-=t formatoptions-=c formatoptions-=r formatoptions-=o formatoptions+=M iskeyword-=# iskeyword-=/
augroup END
