" *******************************
" **  plugin settings
" *******************************

" Disable unnecessary default plugins
" https://github.com/lambdalisue/dotfiles/blob/master/nvim/init.vim
" NOTE: The Netrw is use to download a missing spellfile
" let g:loaded_netrw             = 1
" let g:loaded_netrwPlugin       = 1
" let g:loaded_netrwSettings     = 1
" let g:loaded_netrwFileHandlers = 1
let g:loaded_fzf_vim = 1


" *******************************
" **  netrw settings
" *******************************
" 上のヘルプコメントを隠す
let g:netrw_banner = 0
" tree形式で表示
let g:netrw_liststyle = 3
" サイズ表示を1024baseなK,M,G表記にする
let g:netrw_sizestyle = "H"
" 左右分割を右側に開く
let g:netrw_altv = 1


" *******************************
" **  conceal?
" *******************************
" jsonのconcealを無効にする
" 今はconceal自体を無効化しているのでコメントアウト
" let g:vim_json_conceal = 0


" *******************************
" **  minpac
" *******************************

if v:false
let s:minpac_dir = $XDG_CACHE_HOME . '/nvim/minpac'
execute 'set packpath^=' . s:minpac_dir

if isdirectory (s:minpac_dir)
  augroup minpac_packadd
    autocmd!
    autocmd VimEnter * ++once call pack#VimEnter ()
    autocmd InsertEnter * ++once call pack#InsertEnter ()
    autocmd CmdUndefined * call pack#CmdUndefined (expand ('<afile>'))
    " autocmd BufNewFile,BufReadPost *.* call pack#BufReadPost (expand ('<afile>:t:s/\v^[^.]*//'))
    autocmd FileType * call pack#FileType (expand ('<amatch>'))
  augroup END

  " *******************************
  " **  packadd
  " *******************************
  " ftpluginなど、事前にロードが必要なもの

  packadd denops.vim
  packadd vim-fish

else
  call system ('git clone --depth 1 https://github.com/k-takata/minpac.git ' . s:minpac_dir . '/pack/minpac/opt/minpac')
  call pack#init ()
  call minpac#update ()
endif
endif
