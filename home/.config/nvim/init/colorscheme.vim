" *******************************
" **  colorscheme
" *******************************

" colorscheme読み込み時に必ずやるはずだからいらない処理
" colorschemeをreset
" colorschemeを設定しないとき用(?)
highlight clear
if exists ("syntax_on")
  syntax reset
endif

" 色修正
function! s:fix_color () abort
  " highlight Normal ctermbg=none
  " highlight CursorLineNr ctermfg=15
  highlight PmenuSel blend=0
  highlight StatusLine cterm=none ctermfg=254 ctermbg=234 gui=none guifg=#d9d7ce guibg=#272d38
endfunction

augroup fix_color
  autocmd!
  autocmd ColorScheme * call s:fix_color ()
augroup END

" colorschemeの設定
" note: colorscheme defaultはbackgroundを書き換えるのでdefaultがいい場合は何も読み込まないことを推奨
" 読み込み失敗してもエラーを吐かないように例外処理
try
  colorscheme my-theme
catch /:E185:/
endtry
