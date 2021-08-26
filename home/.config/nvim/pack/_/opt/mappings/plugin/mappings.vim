scriptencoding utf-8

"---------------------------------------------------------------------------"
" Commands \ Modes | Normal | Insert | Command | Visual | Select | Operator |
"------------------|--------|--------|---------|--------|--------|----------|
" map  / noremap   |    @   |   -    |    -    |   @    |   @    |    @     |
" nmap / nnoremap  |    @   |   -    |    -    |   -    |   -    |    -     |
" vmap / vnoremap  |    -   |   -    |    -    |   @    |   @    |    -     |
" omap / onoremap  |    -   |   -    |    -    |   -    |   -    |    @     |
" xmap / xnoremap  |    -   |   -    |    -    |   @    |   -    |    -     |
" smap / snoremap  |    -   |   -    |    -    |   -    |   @    |    -     |
" map! / noremap!  |    -   |   @    |    @    |   -    |   -    |    -     |
" imap / inoremap  |    -   |   @    |    -    |   -    |   -    |    -     |
" cmap / cnoremap  |    -   |   -    |    @    |   -    |   -    |    -     |
"---------------------------------------------------------------------------"

" --------------------------------
"  誤爆防止
" --------------------------------

" 保存せずに破棄の誤爆防止
nnoremap ZQ <Nop>
nnoremap ZZ <Nop>

" 中ボタンによる貼り付けを無効
nnoremap <MiddleMouse> <Nop>
vnoremap <MiddleMouse> <Nop>

" disable Ex mode
nnoremap Q <Nop>
nnoremap gQ <Nop>

" disable commandline window?
nnoremap q: <Nop>


" --------------------------------
"  挙動修正
" --------------------------------

" 入れ替え
"nnoremap ; :
"nnoremap : ;
"xnoremap ; :
"xnoremap : ;
nnoremap <CR> :
xnoremap <CR> :

" Shift-Tabでインデントを1つ減らす
"nnoremap <S-Tab> <<

" <Tab>でtab切り替え
nnoremap <Tab> gt
nnoremap <S-Tab> gT
nnoremap <C-w><Tab> gt
nnoremap <C-w><S-Tab> gT

" 見た目上での縦移動(wrapしてできた行を複数行とみなす？)
" カウントを指定した場合は正しく移動
nnoremap <silent> <expr> j v:count > 0 ? 'j' : 'gj'
nnoremap <silent> <expr> k v:count > 0 ? 'k' : 'gk'
xnoremap <silent> <expr> j v:count > 0 ? 'j' : 'gj'
xnoremap <silent> <expr> k v:count > 0 ? 'k' : 'gk'
nnoremap <silent> <expr> <Down> v:count > 0 ? 'j' : 'gj'
nnoremap <silent> <expr> <Up>   v:count > 0 ? 'k' : 'gk'
xnoremap <silent> <expr> <Down> v:count > 0 ? 'j' : 'gj'
xnoremap <silent> <expr> <Up>   v:count > 0 ? 'k' : 'gk'


" ビジュアルモードでインデント調整時に選択範囲を解除しない
"xnoremap < <gv
"xnoremap > >gv

nnoremap f<CR> $

nnoremap # #*N

nnoremap G Gzz

" nnoremap <F5> <Cmd>call system('deno run --allow-all ./generator.ts > fantasy.vim')\|Reload<CR>

" インデントを考慮した<Home>
nnoremap <silent> <expr> <Home> strpart (getline ('.'), 0, col ('.') - 1) =~# '\v^\s+$' ? "0" : "^"
vnoremap <silent> <expr> <Home> strpart (getline ('.'), 0, col ('.') - 1) =~# '\v^\s+$' ? "0" : "^"
inoremap <silent> <expr> <Home> '<C-o>' . (strpart (getline ('.'), 0, col ('.') - 1) =~# '\v^\s+$' ? "0" : "^")

" --------------------------------
"  機能追加
" --------------------------------

" 全部閉じて終了
nnoremap <silent> <C-q> <Cmd>confirm qall<CR>

" ファイルチェックして再描画！
nnoremap <C-l> <Cmd>checktime<CR><C-l>

" Shift-Yで行末までヤンク
nnoremap Y y$

" 選択範囲をヤンクした文字列で上書き時にレジスタを汚さない
" xnoremap p pgvy
xnoremap p "_xP

" 選択中にCtrl-Cでクリップボードにコピー
vnoremap <C-c> "+y

" 移動系
" 戻る
nnoremap <M-Left> <C-o>
" 進む
nnoremap <M-Right> <C-i>

" 入れ替え
nnoremap <expr> <M-Up> '<Cmd>move .-' . (v:count > 0 ? v:count + 1 : 2) . '<CR>'
nnoremap <expr> <M-Down> '<Cmd>move .+' . (v:count > 0 ? v:count : 1) . '<CR>'
" 範囲選択での入れ替え
xnoremap <M-Up> :move '<-2<CR>gv
xnoremap <M-Down> :move '>+1<CR>gv

" Open Terminal
nnoremap <M-t> <Cmd>Hterminal<CR>

" --------------------------------
"  <Space>
" --------------------------------

nnoremap <Space><Esc> <Nop>

" 現在のウインドウを新しいタブに移動
nnoremap <Space><Tab> <C-w>T

" 空白1文字挿入
nnoremap <Space>i i<Cmd>call mappings#insert_one()<CR>
nnoremap <Space>a a<Cmd>call mappings#insert_one()<CR>

" 閉じる
nnoremap <silent> <Space>q <Cmd>close<CR>

" 保存
nnoremap <Space>w <Cmd>w<CR>

" ファイルを開く
" nnoremap <Space>e :<C-u>e<Space>
" nnoremap <Space>e <Cmd>Fern . -reveal=% -drawer -toggle<CR>
nnoremap <Space>e <Cmd>Files<CR>

" Open New Tab
nnoremap <Space>t <Cmd>tabnew<CR>

" 改行挿入
nnoremap <Space>o o<Space><C-u><Esc>
nnoremap <Space>O O<Space><C-u><Esc>

" Paste from clipboard
nnoremap <Space>p "+p
nnoremap <Space>P "+P

" Split Horizontally
nnoremap <Space>s <C-w>s

" Run FZF
" nnoremap <Space>f <Cmd>Files<CR>

" git ls-files | fzf
nnoremap <Space>g <Cmd>GFiles<CR>

nnoremap <Space>h ^
nnoremap <Space>l $

nnoremap <Space>; :
xnoremap <Space>; :

" Split Vertically
nnoremap <Space>v <C-w>v

" バッファ一覧
nnoremap <Space>b <Cmd>Buffers<CR>

" 新規
nnoremap <Space>n <Cmd>enew<CR>

" open config file
nnoremap <Space>, <Cmd>edit $MYVIMRC<CR>
nnoremap <M-,> <Cmd>edit $MYVIMRC<CR>

nnoremap <silent> <Space>1 <Cmd>setlocal cursorline! cursorcolumn!<CR>
nnoremap <silent> <Space>2 <Cmd>setlocal relativenumber!<CR>

nnoremap <silent> <Space>3 <Cmd>nohlsearch<CR>

" 行末
nnoremap <Space>4 $

nnoremap <Space>5 %

nnoremap <silent> <Space>7 <Cmd>setlocal spell!<CR>

nnoremap <Space>8 *
" nnoremap <silent> <Space>0 <Cmd>setlocal paste!<CR>


" --------------------------------
"  テキストオブジェクト
" --------------------------------

" ビジュアルモードでCtrl-Aで全選択
vnoremap <C-a> gg0oG$

" allテキストオブジェクト ファイル全体
xnoremap all gg0oG$
onoremap all <Cmd>normal! vgg0oG$<CR>

xnoremap il g_o0o
onoremap il <Cmd>normal! v_o$h<CR>

"xnoremap <Space> gE<Space>f<Space>ow<BS>F<Space>


" --------------------------------
"  commentout
" --------------------------------

" Linuxでは<C-/>は<C-_>で設定しないといけないらしい
nmap <C-_> <Plug>CommentaryLine
imap <C-_> <C-o><Plug>CommentaryLine
xmap <C-_> <Plug>Commentary


" --------------------------------
"  netrw
" --------------------------------
" nnoremap <silent> <C-e> <Cmd>call <SID>toggle_netrw ()<CR>
nnoremap <C-e> <Cmd>Fern . -reveal=% -drawer -toggle<CR>


" --------------------------------
"  surround
" --------------------------------

" 選択モードで選択中の範囲を囲む
xmap s <Plug>(surround)
" ()
xnoremap sb "zc(<C-r><C-o>z)<Esc>
xnoremap <Plug>(surround)( "zc(<C-r><C-o>z)<Esc>
xmap <Plug>(surround)) <Plug>(surround)(
" {}
xnoremap <Plug>(surround){ "zc{<C-r><C-o>z}<Esc>
xmap <Plug>(surround)} <Plug>(surround){
" []
xnoremap <Plug>(surround)[ "zc[<C-r><C-o>z]<Esc>
xmap <Plug>(surround)] <Plug>(surround)[
" <>
xnoremap <Plug>(surround)< "zc<<C-r><C-o>z><Esc>
xmap <Plug>(surround)> <Plug>(surround)<
" ""
xnoremap <Plug>(surround)" "zc"<C-r><C-o>z"<Esc>
" ''
xnoremap <Plug>(surround)' "zc'<C-r><C-o>z'<Esc>
" ``
xnoremap <Plug>(surround)` "zc`<C-r><C-o>z`<Esc>

" 囲んでいる括弧を削除する
nmap ds <Plug>(dsurround)
" ()
nnoremap <Plug>(dsurround)b "zcib<BS><Del><C-r><C-o>z<Esc>
nnoremap <Plug>(dsurround)( "zci(<BS><Del><C-r><C-o>z<Esc>
nmap <Plug>(dsurround)) <Plug>(dsurround)(
" {}
nnoremap <Plug>(dsurround){ "zci{<BS><Del><C-r><C-o>z<Esc>
nmap <Plug>(dsurround)} <Plug>(dsurround){
" []
nnoremap <Plug>(dsurround)[ "zci[<BS><Del><C-r><C-o>z<Esc>
nmap <Plug>(dsurround)] <Plug>(dsurround)[
" <>
nnoremap <Plug>(dsurround)< "zci<<BS><Del><C-r><C-o>z<Esc>
nmap <Plug>(dsurround)> <Plug>(dsurround)<
" ""
nnoremap <Plug>(dsurround)" "zci"<BS><Del><C-r><C-o>z<Esc>
"Ma ''
nnoremap <Plug>(dsurround)' "zci'<BS><Del><C-r><C-o>z<Esc>
" ``
nnoremap <Plug>(dsurround)` "zci`<BS><Del><C-r><C-o>z<Esc>


" --------------------------------
"  command mode
" --------------------------------

" 補完メニューが表示されているときの挙動修正
cnoremap <silent><expr> <CR> wildmenumode () ? '<End>' : '<CR>'
" cnoremap <silent><expr> <Left> wildmenumode () ? '<End>' : '<Left>'
" cnoremap <silent><expr> <Right> wildmenumode () ? '<End>' : '<Right>'

" Better <C-n>/<C-p> in Command
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <Up> <C-p>
cnoremap <Down> <C-n>

" draw cursor
" cnoremap <Left> <Left><Cmd>redraw<CR>
" cnoremap <Right> <Right><Cmd>redraw<CR>

cnoremap <C-R> <Esc><Cmd>History:<CR>

" --------------------------------
"  Terminal
" --------------------------------

"tnoremap <Esc><Esc> <C-\><C-n>
" クリックでterminal windowを選択時にnormalモードに戻らないようにする
tnoremap <LeftRelease> <Nop>
tmap <C-w> <C-\><C-n><C-w>

" {{{
function! s:toggle_netrw () abort
  let exists_netrw = 0
  for i in range (1, bufnr ('$'))
    if getbufvar (i, '&filetype') == 'netrw'
      execute 'bwipeout ' . i
      let exists_netrw = 1
      break
    endif
  endfor
  if !exists_netrw
    topleft vertical new
    vertical resize 30
    Explore
    setlocal winfixwidth
    wincmd p
  endif
endfunction
" }}}
