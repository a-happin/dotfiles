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

" colorschemeの設定
" note: colorscheme defaultはbackgroundを書き換えるのでdefaultがいい場合は何も読み込まないことを推奨
" 読み込み失敗してもエラーを吐かないように例外処理
try
  colorscheme blue-theme
catch /:E185:/
endtry

" highlight Normal ctermbg=none
" highlight CursorLineNr ctermfg=15
highlight PmenuSel blend=0

