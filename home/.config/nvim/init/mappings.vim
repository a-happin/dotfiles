"----------------------------------------------------------------------------------------------"
" Commands \ Modes | Normal | Insert | Command | Visual | Select | Operator | Terminal | Lang? |
"------------------|--------|--------|---------|--------|--------|----------|----------|-------|
" map  / noremap   |   @    |   -    |    -    |   @    |   @    |    @     |    -     |   -   |
" nmap / nnoremap  |   @    |   -    |    -    |   -    |   -    |    -     |    -     |   -   |
" map! / noremap!  |   -    |   @    |    @    |   -    |   -    |    -     |    -     |   -   |
" imap / inoremap  |   -    |   @    |    -    |   -    |   -    |    -     |    -     |   -   |
" cmap / cnoremap  |   -    |   -    |    @    |   -    |   -    |    -     |    -     |   -   |
" vmap / vnoremap  |   -    |   -    |    -    |   @    |   @    |    -     |    -     |   -   |
" xmap / xnoremap  |   -    |   -    |    -    |   @    |   -    |    -     |    -     |   -   |
" smap / snoremap  |   -    |   -    |    -    |   -    |   @    |    -     |    -     |   -   |
" omap / onoremap  |   -    |   -    |    -    |   -    |   -    |    @     |    -     |   -   |
" tmap / tnoremap  |   -    |   -    |    -    |   -    |   -    |    -     |    @     |   -   |
" lmap / lnoremap  |   -    |  @(*)  |   @(*)  |   -    |   -    |    -     |    -     |   @   |
"----------------------------------------------------------------------------------------------"
" @(*): &iminsert == 1

" 移動系コマンドはnoremapで定義->printable charaterの場合はsunmapする
" noremalモードでなんやかんやするものはnnoremap
" visualモードでなんやかんやするものはxnoremap
" テキストオブジェクト: xnoremap & onoremap

function! s:nxnoremap (lhs, rhs) "noabort
  execute 'nnoremap' a:lhs a:rhs
  execute 'xnoremap' a:lhs a:rhs
endfunction

" insertモードで使えない文字の移動コマンド用
function! s:noxnoremap (lhs, rhs) "noabort
  execute 'nnoremap' a:lhs a:rhs
  execute 'onoremap' a:lhs a:rhs
  execute 'xnoremap' a:lhs a:rhs
endfunction

" 全モードで定義
" lhs=<M-…>用
" rhsは<Cmd>以外無理かも
function! s:anoremap (lhs, rhs) "noabort
  execute 'noremap' a:lhs a:rhs
  execute 'noremap!' a:lhs a:rhs
  execute 'tnoremap' a:lhs a:rhs
endfunction

" --------------------------------
"  誤爆防止
" --------------------------------

" 保存せずに破棄の誤爆防止
nnoremap ZQ <Nop>
" 保存してウインドウを閉じる
nnoremap ZZ <Nop>

" 中ボタンによる貼り付けを無効
noremap <MiddleMouse> <Nop>

" disable Ex mode
nnoremap Q <Nop>
nnoremap gQ <Nop>

" disable commandline window
nnoremap q: <Nop>

" xと同じ
nnoremap <Del> <Nop>
nnoremap <S-Del> <Nop>
nnoremap <C-Del> <Nop>

" helpを開かないようにする
nnoremap <F1> <Nop>
inoremap <F1> <Nop>

" --------------------------------
"  不完全コマンド系
" --------------------------------
" ただのキー入れ替えなど、単体で操作が完結しないタイプのmapping

" 入れ替え
"nnoremap ; :
"nnoremap : ;
"xnoremap ; :
"xnoremap : ;
" マイクラでチャットを開くキーをEnterにしている影響
" ちなみにたまに困る(helpとか)
call s:nxnoremap ('<CR>', ':')

" digraphs
" call s:noxnoremap ('fj', 'f<C-k>j')
" call s:noxnoremap ('fz', 'f<C-k>z')
" call s:noxnoremap ('Fj', 'F<C-k>j')
" call s:noxnoremap ('Fz', 'F<C-k>z')
" call s:noxnoremap ('tj', 't<C-k>j')
" call s:noxnoremap ('tz', 't<C-k>z')
" call s:noxnoremap ('Tj', 'T<C-k>j')
" call s:noxnoremap ('Tz', 'T<C-k>z')


" --------------------------------
"  コマンド/オペレータ系[Normal]
" --------------------------------

" Shift-Yで行末までヤンク
" デフォルトがこれになったとかなんとか
nnoremap Y y$

" ファイルチェックして再描画！
" nnoremap <C-l> <Cmd>checktime<CR><C-l>

nnoremap gf <Cmd>call open#gf ()<CR>
" xnoremap gfもしたいけどなんかうまくいかない(open#gf_vがバグってる)

" Shift-Tabでインデントを1つ減らす
"nnoremap <S-Tab> <<

" <Tab>でtab切り替え
nnoremap <Tab> gt
nnoremap <S-Tab> gT
" nnoremap <C-w><Tab> gt
" nnoremap <C-w><S-Tab> gT

" nnoremap f<CR> $

" nnoremap <F5> <Cmd>call system('deno run --allow-all ./generator.ts > fantasy.vim')\|Reload<CR>

" nnoremap <BS> <C-o>

" Ctrl-qでnvimを終了する
" もとの動作はVisual Block Modeに入る Ctrl-vでいいよね
" nnoremap <C-q> <Cmd>confirm qall<CR>
nnoremap <C-q> <C-c>

" Ctrl-wで閉じる
" もとの動作はウインドウ操作系
" <C-w>をすべて<M-?>に退避させたしいいでしょ！
" ↑ やりすぎ
" nnoremap <C-w> <Cmd>confirm q<CR>

" Ctrl-tで新しいタブを開く
" もとの動作はJump to [count] older entry in the tag stack
" 代替動作はCtrl-RightButton, g RightButton
nnoremap <C-t> <Cmd>tab split<CR>


" TODO: 後で変える
nnoremap <F3> <Cmd>call my_notify#inspect(#{col: col('.'), line: line('.'), bufwinnr: bufwinnr(bufnr()), screencol: screencol(), screenrow: screenrow(), screenpos: screenpos(bufwinnr(bufnr()),line('.'),col('.')),virtcol: virtcol(".", 1), wincol: wincol(), winline: winline()})<CR>
vnoremap <F3> <Cmd>call my_notify#inspect(#{col: col('.'), line: line('.'), col_v:col('v'), line_v:line('v'), region: getregion(getpos('v'), getpos('.'), #{type: mode()}), mode: mode()})<CR>
nnoremap <F5> <Cmd>Vterminal cargo test<CR>

" --------------------------------
"  コマンド/オペレータ系[Visual]
" --------------------------------

" ヤンクでカーソル移動をしないようにする
xnoremap <expr> y join (['mz"', v:register, 'y`z<Cmd>delmarks z<CR>'], '')

" 選択範囲をヤンクした文字列で上書き時にレジスタを汚さない
" xnoremap p pgvy
" xnoremap p "_xP
" xnoremap <expr> p join (['pgv"', v:register, 'y`>'], '')
xnoremap p P

" 選択中にCtrl-Cでクリップボードにコピー
vnoremap <C-c> "+y

" 選択時はインデント調整にする
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" ビジュアルモードでインデント調整時に選択範囲を解除しない
"xnoremap < <gv
"xnoremap > >gv

" --------------------------------
"  カーソル移動系
" --------------------------------

" 見た目上での縦移動(wrapしてできた行を複数行とみなす？)
" カウントを指定した場合は正しく移動

call s:noxnoremap ('<expr> j', 'v:count > 0 ? "j" : luaeval ("require \"suppress_key_repeating\".suppress_key_repeating (\"gj\")")')
call s:noxnoremap ('<expr> k', 'v:count > 0 ? "k" : luaeval ("require \"suppress_key_repeating\".suppress_key_repeating (\"gk\")")')
noremap <expr> <Down> v:count > 0 ? 'j' : luaeval ('require "suppress_key_repeating".suppress_key_repeating ("gj")')
noremap <expr> <Up>   v:count > 0 ? 'k' : luaeval ('require "suppress_key_repeating".suppress_key_repeating ("gk")')

" call s:noxnoremap ('<expr> j', 'v:count > 0 ? "j" : "gj"')
" call s:noxnoremap ('<expr> k', 'v:count > 0 ? "k" : "gk"')
" noremap <expr> <Down> v:count > 0 ? 'j' : 'gj'
" noremap <expr> <Up>   v:count > 0 ? 'k' : 'gk'

" キーリピート抑制
call s:noxnoremap ('<expr> h', 'luaeval ("require \"suppress_key_repeating\".suppress_key_repeating (\"h\")")')
call s:noxnoremap ('<expr> l', 'luaeval ("require \"suppress_key_repeating\".suppress_key_repeating (\"l\")")')
call s:noxnoremap ('<expr> <Left>', 'luaeval ("require \"suppress_key_repeating\".suppress_key_repeating (\"<Left>\")")')
call s:noxnoremap ('<expr> <Right>', 'luaeval ("require \"suppress_key_repeating\".suppress_key_repeating (\"<Right>\")")')

" 末尾に移動した後スクロール位置を調整する
call s:noxnoremap ('G', 'Gzz')

" Shift+Arrowキーの修正。Shiftの離し忘れで意図せずに急に飛ぶとつらい。
" set keymodel=startsel で解決. visual modeが開始するが
" noremap <S-Left> <Left>
" noremap <S-Right> <Right>
" noremap <S-Up> <Up>
" noremap <S-Down> <Down>

" インデントを考慮した<Home>
noremap <silent> <expr> <Home> strpart (getline ('.'), 0, col ('.') - 1) =~# '\v^\s+$' ? "0" : "^"
inoremap <silent> <expr> <Home> strpart (getline ('.'), 0, col ('.') - 1) =~# '\v^\s+$' ? '<Home>' : '<C-o>^'

" exclusive <End>
vnoremap <expr> <End> &selection ==# 'inclusive' ? '<End><Left>' : '<End>'
onoremap <expr> <End> &selection ==# 'inclusive' ? '<End><Left>' : '<End>'
noremap <expr> <S-End> &selection ==# 'inclusive' ? '<S-End><Left>' : '<S-End>'

" うわ急に飛ぶな
nmap <C-Home> <Home>
nmap <C-S-Home> <S-Home>
nmap <C-End> <End>
nmap <C-S-End> <S-End>
noremap <PageUp> <C-y>
noremap <S-PageUp> <C-y>
noremap <PageDown> <C-e>
noremap <S-PageDown> <C-e>

" Ctrl-Page*はタブ切り替えだったからいいとして、
" Ctrl+Shift+Page*をブラウザに合わせる
call s:anoremap ('<C-S-PageUp>', '<Cmd>-tabmove<CR>')
call s:anoremap ('<C-S-PageDown>', '<Cmd>+tabmove<CR>')

" (前|次)のquickfix
nnoremap [q <Cmd>cprev<CR>
nnoremap ]q <Cmd>cnext<CR>


" ジャンプせずに検索する
function! s:asterisk () abort
  let cword = escape (expand ('<cword>'), '~"\.^$[]*')
  return 'ge/\<' . cword . '\>' . "\<CR>"
endfunction

" 一瞬だけ
function! s:flash_hlsearch_callback (_) abort
  set nohlsearch
  let s:flash_hlsearch_timer_id = 'invalid'
endfunction
function! s:flash_hlsearch () abort
  let timer_id = get (s:, 'flash_hlsearch_timer_id', 'invalid')
  if timer_id !=# 'invalid'
    call timer_stop (timer_id)
  endif
  set hlsearch
  let s:flash_hlsearch_timer_id = timer_start (300, function ('s:flash_hlsearch_callback'))
endfunction
call s:noxnoremap ('<expr> *', '<SID>asterisk() . "<Cmd>call <SID>flash_hlsearch()<CR>"')
" 検索方向を*と揃える
call s:noxnoremap ('<expr> #', '<SID>asterisk() . "<Cmd>call <SID>flash_hlsearch()<CR>"')
call s:noxnoremap ('n', 'n<Cmd>call <SID>flash_hlsearch()<CR>')
call s:noxnoremap ('N', 'N<Cmd>call <SID>flash_hlsearch()<CR>')

" nnoremap w <Plug>(wasd_move)
" nnoremap <Plug>(wasd_move)w gk<Plug>(wasd_move)
" nnoremap <Plug>(wasd_move)a <Cmd>normal! h<CR><Plug>(wasd_move)
" nnoremap <Plug>(wasd_move)s gj<Plug>(wasd_move)
" nnoremap <Plug>(wasd_move)d <Cmd>normal! l<CR><Plug>(wasd_move)
" nnoremap <Plug>(wasd_move)<S-w> 3gk<Plug>(wasd_move)
" nnoremap <Plug>(wasd_move)<S-a> b<Plug>(wasd_move)
" nnoremap <Plug>(wasd_move)<S-s> 3gj<Plug>(wasd_move)
" nnoremap <Plug>(wasd_move)<S-d> e<Plug>(wasd_move)
" nnoremap <Plug>(wasd_move)<C-w> 3gk<Plug>(wasd_move)
" nnoremap <Plug>(wasd_move)<C-a> b<Plug>(wasd_move)
" nnoremap <Plug>(wasd_move)<C-s> 3gj<Plug>(wasd_move)
" nnoremap <Plug>(wasd_move)<C-d> e<Plug>(wasd_move)


" --------------------------------
"  Mouse
" --------------------------------

" ダブルクリックで単語選択
" トリプルクリックで行選択
" クアドラプルクリックでパラグラフ選択(参考: VSCodeは全選択)
function! s:double_click () abort
  if &buftype ==# 'help'
    return "\<2-LeftMouse>"
  else
    let c = matchstr (getline ('.'), '.', col ('.') - 1)
    if c =~# '\v^\k$'
      return "viw"
    elseif c =~# '\v^[(){}[\]<>"''`]$'
      return "va" . c
    else
      return "viW"
    endif
  endif
endfunction
nnoremap <silent> <expr> <2-LeftMouse> <SID>double_click ()
nnoremap <3-LeftMouse> <Nop>
nnoremap <4-LeftMouse> <Nop>
vnoremap <2-LeftMouse> <Nop>
" vnoremap <3-LeftMouse> V
vnoremap <4-LeftMouse> ip

" 挿入モードのときはSELECT MODEにする
inoremap <silent> <expr> <2-LeftMouse> '<C-o>' . <SID>double_click () . '<C-g>'
inoremap <3-LeftMouse> <Nop>
inoremap <4-LeftMouse> <Nop>


" --------------------------------
"  テキストオブジェクト
" --------------------------------

" ビジュアルモードでCtrl-Aで全選択
vnoremap <C-a> gg0oG$
onoremap <C-a> <Cmd>normal! vgg0oG$<CR>

" allテキストオブジェクト ファイル全体
xnoremap all gg0oG$
onoremap all <Cmd>normal! vgg0oG$<CR>

" 現在の行(改行含まない)
" 行の最後に移動するのにいろいろあった。
" * $h …… &selection によって挙動が違う。空行かつhで行をまたぐ設定のときバグる
" * g_ …… 末尾が空白だった場合に選択できない
" また、カーソルが開始位置と終了位置どっちにあるかによって挙動が……など問題が結構ある。
" 現在は裏技チックだがVisual Blockモードにすることで解決している
xnoremap <silent> <expr> il (visualmode () ==# '<C-v>' ? '' : '<C-v>') . '0o$'
onoremap il <Cmd>normal! <C-v>0o$<CR>

"xnoremap <Space> gE<Space>f<Space>ow<BS>F<Space>

" カーソル直下の文字が囲み文字だった場合に便利なテキストオブジェクト
" auで囲み文字込み、iuで内側
xnoremap <silent> <expr> au 'a' . matchstr (getline ('.'), '.', col ('.') - 1)
onoremap <silent> <expr> au 'a' . matchstr (getline ('.'), '.', col ('.') - 1)
xnoremap <silent> <expr> iu 'i' . matchstr (getline ('.'), '.', col ('.') - 1)
onoremap <silent> <expr> iu 'i' . matchstr (getline ('.'), '.', col ('.') - 1)

" Shiftって遠いよね
xnoremap a<Space> aW
onoremap a<Space> aW
xnoremap i<Space> iW
onoremap i<Space> iW

" 空白を含まないようにする
" 参考: help i"
xnoremap a" 2i"
onoremap a" 2i"
xnoremap a' 2i'
onoremap a' 2i'
xnoremap a` 2i`
onoremap a` 2i`


" --------------------------------
"  Alt key mappings
" --------------------------------

" function! s:alt_wincmd () abort
"   for i in split('qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890`~!@#$%^&*()-=_+[]{}\;:''",.<>/?', '.\zs')
"     call s:anoremap ('<M-' . i . '>', '<Cmd>wincmd ' . i . '<CR>')
"   endfor
"   call s:anoremap ('<M-bar>', '<Cmd>wincmd <bar><CR>')
" endfunction
" call s:alt_wincmd ()


"" 全部閉じて終了
""call s:anoremap ('<M-Q>', '<Cmd>confirm qall<CR>')
"" call s:anoremap ('<M-q>', '<Cmd>confirm qall<CR>')
""call s:anoremap ('<M-q>', '<Cmd>confirm q<CR>')
" call s:anoremap ('<M-q>', '<Cmd>normal! <C-c><CR>')

"" nmap <M-w> <C-w>

" Open File Explorer
" nnoremap <C-e> <Cmd>call <SID>toggle_netrw ()<CR>
call s:anoremap ('<M-e>', '<Cmd>Fern . -reveal=% -drawer -toggle<CR>')

" call s:anoremap ('<M-g>', '<C-\><C-n><C-w>g')

" Toggle Terminal
call s:anoremap ('<M-CR>', '<Cmd>ToggleTerminal<CR>')

" call s:anoremap ('<M-?>', '<Cmd>vertical help CTRL-w<CR>')

call s:anoremap ('<M-w>', '<Cmd>normal! gk<CR>')
call s:anoremap ('<M-a>', '<Cmd>normal! h<CR>')
call s:anoremap ('<M-s>', '<Cmd>normal! gj<CR>')
call s:anoremap ('<M-d>', '<Cmd>normal! l<CR>')
tnoremap <M-w> <Up>
tnoremap <M-a> <Left>
tnoremap <M-s> <Down>
tnoremap <M-d> <Right>

" LoadSession if current buffer is empty and it's the only buffer
" SaveSession if others
"" call s:anoremap ('<M-s>', '<Cmd>if bufnr ("$") ==# 1 && &modified ==# 0 && empty (&buftype)<bar>LoadSession default<bar>else<bar>SaveSession default<bar>endif<CR>')

"" focus ← ↓ ↑ →  window
"call s:anoremap ('<M-h>', '<Cmd>wincmd h<CR>')
"call s:anoremap ('<M-j>', '<Cmd>wincmd j<CR>')
"call s:anoremap ('<M-k>', '<Cmd>wincmd k<CR>')
"call s:anoremap ('<M-l>', '<Cmd>wincmd l<CR>')
"" focus below/right window
"call s:anoremap ('<M-w>', '<Cmd>wincmd w<CR>')
"" focus above/left window
"call s:anoremap ('<M-W>', '<Cmd>wincmd W<CR>')
"" focus most below/right window
"call s:anoremap ('<M-b>', '<Cmd>wincmd b<CR>')
"" focus most above/left window
"call s:anoremap ('<M-t>', '<Cmd>wincmd t<CR>')
"" focus previous window
"call s:anoremap ('<M-p>', '<Cmd>wincmd p<CR>')

"" move window ← ↓ ↑ →
"call s:anoremap ('<M-H>', '<Cmd>wincmd H<CR>')
"call s:anoremap ('<M-J>', '<Cmd>wincmd J<CR>')
"call s:anoremap ('<M-K>', '<Cmd>wincmd K<CR>')
"call s:anoremap ('<M-L>', '<Cmd>wincmd L<CR>')
"" move window to new tab
"call s:anoremap ('<M-T>', '<Cmd>wincmd T<CR>')

"" split window
"call s:anoremap ('<M-s>', '<Cmd>split<CR>')
"call s:anoremap ('<M-v>', '<Cmd>vsplit<CR>')
"call s:anoremap ('<M-n>', '<Cmd>new<CR>')

"" rotate window (shift: reverse)
"call s:anoremap ('<M-r>', '<Cmd>wincmd r<CR>')
"call s:anoremap ('<M-R>', '<Cmd>wincmd R<CR>')
"" swap current window with next/previous one
"call s:anoremap ('<M-x>', '<Cmd>wincmd x<CR>')

"" hide other window
"call s:anoremap ('<M-o>', '<Cmd>only<CR>')

"" close window
"call s:anoremap ('<M-c>', '<Cmd>confirm close<CR>')

"" resize window
"call s:anoremap ('<M-->', '<Cmd>resize -1<CR>')
"call s:anoremap ('<M-+>', '<Cmd>resize +1<CR>')
"call s:anoremap ('<M-=>', '<Cmd>wincmd =<CR>')
"call s:anoremap ('<M-<>', '<Cmd>vertical resize -1<CR>')
"call s:anoremap ('<M->>', '<Cmd>vertical resize +1<CR>')

" switch tab
call s:anoremap ('<M-1>', '<Cmd>1tabnext<CR>')
call s:anoremap ('<M-2>', '<Cmd>2tabnext<CR>')
call s:anoremap ('<M-3>', '<Cmd>3tabnext<CR>')
call s:anoremap ('<M-4>', '<Cmd>4tabnext<CR>')
call s:anoremap ('<M-5>', '<Cmd>5tabnext<CR>')
call s:anoremap ('<M-6>', '<Cmd>6tabnext<CR>')
call s:anoremap ('<M-7>', '<Cmd>7tabnext<CR>')
call s:anoremap ('<M-8>', '<Cmd>8tabnext<CR>')
call s:anoremap ('<M-9>', '<Cmd>9tabnext<CR>')
call s:anoremap ('<M-0>', '<Cmd>$tabnext<CR>')

" 下が動かないならこっちも
" って思ったけど一応有効にしておくか…
call s:anoremap ('<M-Tab>', '<Cmd>tabnext<CR>')
" doesn't work
"noremap <M-S-Tab> <Cmd>tabprev<CR>


" 戻る
nnoremap <M-Left> <C-o>
" 進む
nnoremap <M-Right> <C-i>

" 入れ替え
nnoremap <expr> <M-Up> '<Cmd>move .-' . (v:count1 + 1) . '<CR>'
nnoremap <expr> <M-Down> '<Cmd>move .+' . (v:count1) . '<CR>'
" 範囲選択での入れ替え
vnoremap <M-Up> :move '<-2<CR>gv
vnoremap <M-Down> :move '>+1<CR>gv


" --------------------------------
"  <Space>
" --------------------------------

nnoremap <Space><Esc> <Nop>

" カーソル下のsyntax highlight表示
nnoremap <Space><F1> <Cmd>Inspect<CR>
nnoremap <Space><F2> <Cmd>echo synIDattr(synID(line("."), col("."), 1), "name")<CR>

" 移動せずに大文字小文字変換
nnoremap <Space>` g~l

nnoremap <Space>1 <Cmd>setlocal cursorline! cursorcolumn!<CR>
" nnoremap <Space>2 <Cmd>setlocal relativenumber!<CR>

" execute macro
nnoremap <Space>2 @q

" switch to alternate buffer
" nnoremap <Space>3 <Cmd>b #<CR>
nnoremap <Space>3 <C-^>

call s:noxnoremap ('<Space>4', '$')
call s:noxnoremap ('<Space>5', '%')
call s:noxnoremap ('<Space>6', '^')
nnoremap <Space>7 <Cmd>setlocal spell!<CR>
call s:noxnoremap ('<expr> <Space>8', '<SID>asterisk() . "<Cmd>call <SID>flash_hlsearch()<CR>"')

" 現在の括弧
call s:noxnoremap ('<Space>9', 'F(')
call s:noxnoremap ('<Space>0', 'f)')

" バッファを閉じる
" nnoremap <Space><BS> <Cmd>confirm bdelete<CR>

" 現在のウインドウを新しいタブに移動
" nnoremap <Space><Tab> <C-w>T
" 新しいタブ
"nnoremap <Space><Tab> <Cmd>tabnew<CR>

" 空白1文字挿入
nnoremap <Space>i i<Cmd>call mappings#insert_one()<CR>
nnoremap <Space>a a<Cmd>call mappings#insert_one()<CR>

" 閉じる
" confirm q でいい説がある
" nnoremap <Space>q <Cmd>try<bar>close<bar>catch /:E444:/<bar>confirm qall<bar>endtry<CR>
nnoremap <Space>q <Cmd>confirm q<CR>

" 保存
nnoremap <Space>w <Cmd>update<CR>

" ファイルを開く
" nnoremap <Space>e :<C-u>e<Space>
" nnoremap <Space>e <Cmd>Fern . -reveal=% -drawer -toggle<CR>
" nnoremap <Space>e <Cmd>Files<CR>
nnoremap <Space>e :<C-u>e <C-r>=expand('%')<CR>

" Restart coc.nvim
" nnoremap <Space>r <Cmd>CocRestart<CR>

" Open New Tab
" nnoremap <Space>t <Cmd>tabnew<CR>
" Open Terminal
" nnoremap <Space>t <Cmd>terminal<CR>
" Move to new tab
" nnoremap <Space>t <Cmd>wincmd T<CR>
" nnoremap <Space>t <C-w>T
" Open the current buffer in a new tab without closing the previous window.
nnoremap <Space>t <Cmd>tab split<CR>

" Copy to clipboard
" call s:nxnoremap ('<Space>y', '"wy')

" 改行挿入
" append関数で追加するとドットリピートできない(なんで？)
nnoremap <Space>o o0<C-d><Esc>
nnoremap <Space>O O0<C-d><Esc>




" Paste from clipboard
" call s:nxnoremap ('<Space>p', '<Cmd>GetWindowsClipboard<CR>p')
" call s:nxnoremap ('<Space>P', '<Cmd>GetWindowsClipboard<CR>P')

" Split Horizontally
" nnoremap <Space>s <C-w>s
" 簡易置き換え
" xnoremap <Space>s "zy:%s/\V<C-r>=escape(@z, '\/')<CR>//g<Left><Left><C-r>=escape(@z, '\/')<CR>
xnoremap <Space>s "zy:%s/\V<C-r>=escape(@z, '\/')<CR>/<C-r>=escape(@z, '\/')<CR>/g

" nnoremap <Space>d lD

" Run FZF
"nnoremap <Space>f <Cmd>Files<CR>
nnoremap <Space>f <Cmd>Telescope find_files<CR>
nnoremap <Space>F <Cmd>call fzf#vim#files("", fzf#vim#with_preview(#{options: ['--reverse']}))<CR>

" git ls-files | fzf
"nnoremap <Space>g <Cmd>GFiles<CR>
nnoremap <Space>g <Cmd>Telescope git_files<CR>
nnoremap <Space>G <Cmd>call fzf#vim#gitfiles("", fzf#vim#with_preview(#{options: ['--reverse']}))<CR>

" 最近開いたファイル
nnoremap <Space>h <Cmd>Telescope recent_files<CR>
nnoremap <Space>H <Cmd>call fzf#vim#history(fzf#vim#with_preview(#{options: ['--reverse']}))<CR>

" wrap考慮の行頭、行末移動
" call s:noxnoremap ('<Space>h', 'g^')
" call s:noxnoremap ('<Space>l', 'g$')
" 戻る、進む
" nnoremap <Space>h <C-o>
" nnoremap <Space>l <C-i>

nnoremap <Space>; :
xnoremap <Space>; :

" nnoremap <Space>z <Cmd>echo 'hello'<CR>
" nnoremap <Space>c <Cmd>close<CR>

" CocList
" LSP側でcode_actionを発火するように割り当てている
" nnoremap <Space>c <Cmd>CocList<CR>

" select last searched text
nnoremap <Space>v gn

" バッファ一覧
"nnoremap <Space>b <Cmd>Buffers<CR>
"nnoremap <Space>b <Cmd>Telescope buffers<CR>
"nnoremap <Space>b <Cmd>lua require 'telescope.builtin'.buffers({entry_maker = require 'telescope.make_entry'.gen_from_buffer()})<CR>
nnoremap <Space>b <Cmd>lua require 'telescope.builtin'.buffers({entry_maker = require 'my_lib/telescope'.gen_from_buffer()})<CR>
nnoremap <Space>B <Cmd>call fzf#vim#buffers("", fzf#vim#with_preview(#{placeholder: "{1}", options: ['--reverse']}))<CR>

" 新規
nnoremap <Space>n <Nop>
nnoremap <Space>nn <Cmd>enew<CR>
nnoremap <Space>ns <Cmd>new<CR>
nnoremap <Space>nv <Cmd>vnew<CR>
nnoremap <Space>n<Tab> <Cmd>tabnew<CR>

" open config file
nnoremap <Space>, <Cmd>tabnew $MYVIMRC \| lcd %:h<CR>

" source this
nnoremap <Space>. <Cmd>SourceThis<CR>

" ripgrep
"nnoremap <Space>/ <Cmd>Rg<CR>
nnoremap <Space>/ <Cmd>Telescope live_grep<CR>

" 選択中の文字列で検索をかける
xnoremap <Space>/ "zy/\V<C-r>=escape(@z, '\/')<CR><CR><Cmd>call <SID>flash_hlsearch()<CR>



" --------------------------------
" 2分探索移動
" --------------------------------
" 参考:
" - https://gist.github.com/tana/9131084 - Vimで二分探索っぽくカーソルを移動する
" - https://zenn.dev/mattn/articles/83c2d4c7645faa - Vim で折り返し行を簡単に移動できるサブモード・テクニック

function! s:binary_move (dir = "") abort
  if !exists('s:binary_move_ctx')
    let s:binary_move_ctx = #{cursorline: &cursorline, cursorcolumn: &cursorcolumn}
    set cursorline cursorcolumn
  endif

  if a:dir ==# 'whole_k' || a:dir ==# 'whole_j'
    if a:dir ==# 'whole_k'
      let s:binary_move_ctx.bottom = line('.')
    else
      let s:binary_move_ctx.top = line('.')
    endif

    let top = exists('s:binary_move_ctx.top') ? s:binary_move_ctx.top : 0
    let bottom = exists('s:binary_move_ctx.bottom') ? s:binary_move_ctx.bottom : line('$') + 1
    if bottom - top < 2
      return
    endif
    let mid = top + (bottom - top) / 2
    call cursor(mid, 0)

  elseif a:dir ==# 'k' || a:dir ==# 'j'
    if a:dir ==# 'k'
      let s:binary_move_ctx.bottom = line('.')
      " if !exists('s:binary_move_ctx.top')
      "   let s:binary_move_ctx.top = line('w0') - 1
      " endif
    else
      let s:binary_move_ctx.top = line('.')
      " if !exists('s:binary_move_ctx.bottom')
      "   let s:binary_move_ctx.bottom = line('w$') + 1
      " endif
    endif

    " let top = exists('s:binary_move_ctx.top') ? s:binary_move_ctx.top : line('w0') - 1
    " let bottom = exists('s:binary_move_ctx.bottom') ? s:binary_move_ctx.bottom : line('w$') + 1
    let top    = line('w0') - 1 | if exists('s:binary_move_ctx.top') && s:binary_move_ctx.top > top | let top = s:binary_move_ctx.top | endif
    let bottom = line('w$') + 1 | if exists('s:binary_move_ctx.bottom') && s:binary_move_ctx.bottom < bottom | let bottom = s:binary_move_ctx.bottom | endif
    if bottom - top < 2
      return
    endif
    let mid = top + (bottom - top) / 2
    call cursor(mid, 0)

  elseif a:dir ==# 'h' || a:dir ==# 'l'
    if a:dir ==# 'h'
      let s:binary_move_ctx.right = charcol('.')
      " if !exists('s:binary_move_ctx.left')
      "   let s:binary_move_ctx.left = 0
      " endif
    else
      let s:binary_move_ctx.left = charcol('.')
      " if !exists('s:binary_move_ctx.right')
      "   let s:binary_move_ctx.right = charcol('$') + 1
      " endif
    endif

    let left = exists('s:binary_move_ctx.left') ? s:binary_move_ctx.left : 0
    let right = exists('s:binary_move_ctx.right') ? s:binary_move_ctx.right : charcol('$') + 1
    if right - left < 2
      return
    endif
    let mid = left + (right - left) / 2
    call setcursorcharpos(0, mid)
  endif
endfunction

function! s:binary_move_clear() "noabort
  let &cursorline = s:binary_move_ctx.cursorline
  let &cursorcolumn = s:binary_move_ctx.cursorcolumn
  unlet s:binary_move_ctx
endfunction

" WIP: does not work
let s:binary_move_start_res = "\<Cmd>call \<SID>binary_move()\<CR>\<Plug>(binary_move)"
function! s:binary_move_start() abort
  " call s:binary_move()
  " return "<Plug>(binary_move)"
  return s:binary_move_start_res
  " return "\<Cmd>call \<SID>binary_move()\<CR>"
  return ""
endfunction

" call s:nxnoremap('<Plug>(binary_move)', "<Cmd>call <SID>binary_move_clear()<CR>")
" nnoremap <Plug>(binary_move) <Cmd>call <SID>binary_move_clear()<CR>
" xnoremap <Plug>(binary_move) <Cmd>call <SID>binary_move_clear()<CR>
" nnoremap <Plug>(binary_move)q <Cmd>call <SID>binary_move_clear()<CR>
" xnoremap <Plug>(binary_move)q <Cmd>call <SID>binary_move_clear()<CR>
" nnoremap <Plug>(binary_move)z zz<Plug>(binary_move)
" xnoremap <Plug>(binary_move)z zz<Plug>(binary_move)
" nnoremap <Plug>(binary_move)m zz<Plug>(binary_move)
" xnoremap <Plug>(binary_move)m zz<Plug>(binary_move)

" function! s:binary_move_register_map(dict, to_zz) abort
"   call s:nxnoremap('<Plug>(binary_move)', "<Cmd>call <SID>binary_move_clear()<CR>")

"   for [d, v] in items(a:dict)
"     for k in v
"       call s:nxnoremap('<Plug>(binary_move)' .. k, "<Cmd>call <SID>binary_move('" .. d[0] .. "')<CR>" .. d[1:] .. "<Plug>(binary_move)")
"       for tzz in a:to_zz
"         call s:nxnoremap('<Plug>(binary_move)' .. tzz .. k, "<Cmd>call <SID>binary_move('" .. d[0] .. "')<CR>zz<Plug>(binary_move)" .. tzz)
"       endfor
"     endfor
"   endfor
" endfunction

function! s:foreach (item_or_items, f) abort
  if type(a:item_or_items) == type([])
    for item in a:item_or_items
      call a:f(item)
    endfor
  else
    call a:f(a:item_or_items)
  endif
endfunction

function! s:binary_move_register_map_v2(dict) abort
  call s:nxnoremap(a:dict.plug, "<Cmd>call <SID>binary_move_clear()<CR>")
  if exists('a:dict.activate')
    call s:foreach(a:dict.activate, {key -> s:nxnoremap(key, "<Cmd>call <SID>binary_move()<CR>" .. a:dict.plug)})
  endif
  " gmはwarpがoffのとき、よくなさそう
  if exists('a:dict.activate_center')
    call s:foreach(a:dict.activate_center, {key -> s:nxnoremap(key, "Mgm<Cmd>call <SID>binary_move()<CR>" .. a:dict.plug)})
  endif
  for dir in "hjkl"
    if exists('a:dict[dir]')
      call s:foreach(a:dict[dir], {key -> s:nxnoremap(a:dict.plug .. key, "<Cmd>call <SID>binary_move('" .. dir .. "')<CR>" .. a:dict.plug)})
    endif
  endfor
  for dir in "jk"
    let x = dir .. 'zz'
    if exists('a:dict[x]')
      call s:foreach(a:dict[x], {key -> s:nxnoremap(a:dict.plug .. key, "<Cmd>call <SID>binary_move('" .. dir .. "')<CR>zz" .. a:dict.plug)})
    endif
    let x = dir .. 'zz_fast'
    if exists('a:dict[x]')
      call s:foreach(a:dict[x], {key -> s:nxnoremap(a:dict.plug .. key, (dir ==# 'k' ? 'zb' : 'zt') .. "<Cmd>call <SID>binary_move('" .. dir .. "')<CR>" .. a:dict.plug)})
    endif
    let x = 'whole_' .. dir
    if exists('a:dict[x]')
      call s:foreach(a:dict[x], {key -> s:nxnoremap(a:dict.plug .. key, "<Cmd>call <SID>binary_move('whole_" .. dir .. "')<CR>zz" .. a:dict.plug)})
    endif
  endfor
  if exists('a:dict.zz')
    call s:foreach(a:dict.zz, {key -> s:nxnoremap(a:dict.plug .. key, "zz" .. a:dict.plug)})
  endif
  if exists('a:dict.M')
    call s:foreach(a:dict.M, {key -> s:nxnoremap(a:dict.plug .. key, "M" .. a:dict.plug)})
  endif
  if exists('a:dict.q')
    call s:foreach(a:dict.q, {key -> s:nxnoremap(a:dict.plug .. key, "<Cmd>call <SID>binary_move_clear()<CR>")})
  endif
  if exists('a:dict.restart')
    call s:foreach(a:dict.restart, {key -> s:nxnoremap(a:dict.plug .. key, "<Cmd>call <SID>binary_move_clear()<CR><Cmd>call <SID>binary_move()<CR>" .. a:dict.plug)})
  endif
endfunction

" nnoremap <Plug>(binary_move)h <Cmd>call <SID>binary_move('h')<CR><Plug>(binary_move)
" nnoremap <Plug>(binary_move)j <Cmd>call <SID>binary_move('j')<CR><Plug>(binary_move)
" nnoremap <Plug>(binary_move)k <Cmd>call <SID>binary_move('k')<CR><Plug>(binary_move)
" nnoremap <Plug>(binary_move)l <Cmd>call <SID>binary_move('l')<CR><Plug>(binary_move)
" nnoremap <Plug>(binary_move)a <Cmd>call <SID>binary_move('h')<CR><Plug>(binary_move)
" nnoremap <Plug>(binary_move)s <Cmd>call <SID>binary_move('j')<CR><Plug>(binary_move)
" nnoremap <Plug>(binary_move)w <Cmd>call <SID>binary_move('k')<CR><Plug>(binary_move)
" nnoremap <Plug>(binary_move)d <Cmd>call <SID>binary_move('l')<CR><Plug>(binary_move)
" nnoremap <Plug>(binary_move)<Left> <Cmd>call <SID>binary_move('h')<CR><Plug>(binary_move)
" nnoremap <Plug>(binary_move)<Down> <Cmd>call <SID>binary_move('j')<CR><Plug>(binary_move)
" nnoremap <Plug>(binary_move)<Up> <Cmd>call <SID>binary_move('k')<CR><Plug>(binary_move)
" nnoremap <Plug>(binary_move)<Right> <Cmd>call <SID>binary_move('l')<CR><Plug>(binary_move)


" nnoremap <Plug>(binary_move)H <Cmd>call <SID>binary_move('h')<CR>zz<Plug>(binary_move)
" nnoremap <Plug>(binary_move)J <Cmd>call <SID>binary_move('j')<CR>zz<Plug>(binary_move)
" nnoremap <Plug>(binary_move)K <Cmd>call <SID>binary_move('k')<CR>zz<Plug>(binary_move)
" nnoremap <Plug>(binary_move)L <Cmd>call <SID>binary_move('l')<CR>zz<Plug>(binary_move)

" xnoremap <Plug>(binary_move)h <Cmd>call <SID>binary_move('h')<CR><Plug>(binary_move)
" xnoremap <Plug>(binary_move)j <Cmd>call <SID>binary_move('j')<CR><Plug>(binary_move)
" xnoremap <Plug>(binary_move)k <Cmd>call <SID>binary_move('k')<CR><Plug>(binary_move)
" xnoremap <Plug>(binary_move)l <Cmd>call <SID>binary_move('l')<CR><Plug>(binary_move)
" xnoremap <Plug>(binary_move)<Left> <Cmd>call <SID>binary_move('h')<CR><Plug>(binary_move)
" xnoremap <Plug>(binary_move)<Down> <Cmd>call <SID>binary_move('j')<CR><Plug>(binary_move)
" xnoremap <Plug>(binary_move)<Up> <Cmd>call <SID>binary_move('k')<CR><Plug>(binary_move)
" xnoremap <Plug>(binary_move)<Right> <Cmd>call <SID>binary_move('l')<CR><Plug>(binary_move)

" nmap <Space>h <Plug>(binary_move)h
" nmap <Space>j <Plug>(binary_move)j
" nmap <Space>k <Plug>(binary_move)k
" nmap <Space>l <Plug>(binary_move)l

" xmap <Space>h <Plug>(binary_move)h
" xmap <Space>j <Plug>(binary_move)j
" xmap <Space>k <Plug>(binary_move)k
" xmap <Space>l <Plug>(binary_move)l

" ダメ
" nmap <expr> mb <SID>binary_move_start()
" xmap <expr> mb <SID>binary_move_start()

" nmap b <Cmd>call <SID>binary_move()<CR><Plug>(binary_move)
" xmap b <Cmd>call <SID>binary_move()<CR><Plug>(binary_move)
" nmap B <Cmd>call <SID>binary_move()<CR><Plug>(binary_move)
" xmap B <Cmd>call <SID>binary_move()<CR><Plug>(binary_move)
" nmap , <Cmd>call <SID>binary_move()<CR><Plug>(binary_move)
" xmap , <Cmd>call <SID>binary_move()<CR><Plug>(binary_move)
" nmap <C-f> <Cmd>call <SID>binary_move()<CR><Plug>(binary_move)f
" xmap <C-f> <Cmd>call <SID>binary_move()<CR><Plug>(binary_move)f

" nnoremap <Plug>(binary_move)b <Cmd>call <SID>binary_move_clear()<CR>b
" xnoremap <Plug>(binary_move)b <Cmd>call <SID>binary_move_clear()<CR>b

" call s:binary_move_register_map_v2(#{
"       \ plug: '<Plug>(binary_move_wasd)',
"       \ activate: 'e',
"       \ activate_center: 'E',
"       \ h: ['a', '<M-a>'],
"       \ j: ['s', '<M-s>'],
"       \ k: ['w', '<M-w>'],
"       \ l: 'd',
"       \ q: 'q',
"       \ zz: 'f',
"       \})

call s:binary_move_register_map_v2(#{
      \ plug: '<Plug>(binary_move)',
      \ activate: ['b', '<M-b>'],
      \ h: ['h', '<M-a>'],
      \ j: ['j', '<M-s>'],
      \ k: ['k', '<M-w>'],
      \ l: ['l', '<M-d>'],
      \ zz: ['z', '<M-z>'],
      \ M: 'm',
      \})
" 中央から開始すると移動量の予測がしやすい
" call s:nxnoremap ('M', "Mgm<Cmd>call <SID>binary_move()<CR><Plug>(binary_move)")

" call s:nxnoremap ('<PageUp>', "<Cmd>call <SID>binary_move('K')<CR>zz<Plug>(binary_move)")
" call s:nxnoremap ('<PageDown>', "<Cmd>call <SID>binary_move('J')<CR>zz<Plug>(binary_move)")
" call s:nxnoremap ('<Plug>(binary_move)<PageUp>', "<Cmd>call <SID>binary_move('K')<CR>zz<Plug>(binary_move)")
" call s:nxnoremap ('<Plug>(binary_move)<PageDown>', "<Cmd>call <SID>binary_move('J')<CR>zz<Plug>(binary_move)")
call s:nxnoremap ('<Space>k', "<Cmd>call <SID>binary_move('k')<CR>zz<Plug>(binary_move)")
call s:nxnoremap ('<Space>j', "<Cmd>call <SID>binary_move('j')<CR>zz<Plug>(binary_move)")

" Tips
" 上に半分移動したい場合はzbでずらしてから移動
" 下に半分移動したい場合はztでずらしてから移動
" すると高速移動できるが、それをやる意味があるかどうかは謎


" --------------------------------
"  commentout
" --------------------------------

" プラグインがないとき用の設定
"try
"  silent nnoremap <unique> <C-_> I//<Space><Esc>
"  silent vnoremap <unique> <C-_> I//<Space><Esc>
"  silent inoremap <unique> <C-_> <C-g>u<C-o>^//<Space>
"catch /:E227:/
"endtry

nmap <C-/> gcc
vmap <C-/> gc

" 一部環境(windows alacritty)で<C-/>が入力できない(?)ため、<C-_>を変わりに使う
nmap <C-_> gcc
vmap <C-_> gc

" --------------------------------
"  surround
" --------------------------------

let s:pairs = {
  \ 'b': ['(', ')'],
  \ '(': ['(', ')'],
  \ ')': ['(', ')'],
  \ 'B': ['{', '}'],
  \ '{': ['{', '}'],
  \ '}': ['{', '}'],
  \ '[': ['[', ']'],
  \ ']': ['[', ']'],
  \ '<': ['<', '>'],
  \ '>': ['<', '>'],
  \}
"👨‍🏻‍🦱

function! s:surround () abort
  let c = getcharstr ()
  " 制御文字(0x80で始まる)と<Esc>はなにもしない
  if c[0] ==# "\x80" || c ==# "\<Esc>"
    return ""
  endif

  let [start, end] = get (s:pairs, c, [c, c])
  " return "\"zc" . start . "\<C-r>\<C-o>z" . end . "\<Cmd>call cursor(0, col ('.') - strlen (getreg ('z')))\<CR>\<Esc>"
  return "\"zc" . start . "\<C-r>\<C-o>z" . end . "\<Esc>"
endfunction

" Visualモードで選択中の範囲を囲む
" xmap s <Plug>(surround)
xnoremap <expr> s <SID>surround ()

"" ()
"xnoremap sb "zc(<C-r><C-o>z)<Esc>
"xnoremap <Plug>(surround)( "zc(<C-r><C-o>z)<Esc>
"xmap <Plug>(surround)) <Plug>(surround)(
"" {}
"xnoremap <Plug>(surround){ "zc{<C-r><C-o>z}<Esc>
"xmap <Plug>(surround)} <Plug>(surround){
"" []
"xnoremap <Plug>(surround)[ "zc[<C-r><C-o>z]<Esc>
"xmap <Plug>(surround)] <Plug>(surround)[
"" <>
"xnoremap <Plug>(surround)< "zc<<C-r><C-o>z><Esc>
"xmap <Plug>(surround)> <Plug>(surround)<
"" ""
"xnoremap <Plug>(surround)" "zc"<C-r><C-o>z"<Esc>
"" ''
"xnoremap <Plug>(surround)' "zc'<C-r><C-o>z'<Esc>
"" ``
"xnoremap <Plug>(surround)` "zc`<C-r><C-o>z`<Esc>
""
"xnoremap <Plug>(surround)~ "zc~<C-r><C-o>z~<Esc>
"xnoremap <Plug>(surround)! "zc!<C-r><C-o>z!<Esc>
"xnoremap <Plug>(surround)@ "zc@<C-r><C-o>z@<Esc>
"xnoremap <Plug>(surround)# "zc#<C-r><C-o>z#<Esc>
"xnoremap <Plug>(surround)$ "zc$<C-r><C-o>z$<Esc>
"xnoremap <Plug>(surround)% "zc%<C-r><C-o>z%<Esc>
"xnoremap <Plug>(surround)^ "zc^<C-r><C-o>z^<Esc>
"xnoremap <Plug>(surround)& "zc&<C-r><C-o>z&<Esc>
"xnoremap <Plug>(surround)* "zc*<C-r><C-o>z*<Esc>
"xnoremap <Plug>(surround)- "zc-<C-r><C-o>z-<Esc>
"xnoremap <Plug>(surround)_ "zc_<C-r><C-o>z_<Esc>
"xnoremap <Plug>(surround)= "zc=<C-r><C-o>z=<Esc>
"xnoremap <Plug>(surround)+ "zc+<C-r><C-o>z+<Esc>
"xnoremap <Plug>(surround)<bar> "zc<bar><C-r><C-o>z<bar><Esc>
"xnoremap <Plug>(surround); "zc;<C-r><C-o>z;<Esc>
"xnoremap <Plug>(surround): "zc:<C-r><C-o>z:<Esc>
"xnoremap <Plug>(surround), "zc,<C-r><C-o>z,<Esc>
"xnoremap <Plug>(surround). "zc.<C-r><C-o>z.<Esc>
"xnoremap <Plug>(surround)/ "zc/<C-r><C-o>z/<Esc>
"xnoremap <Plug>(surround)? "zc?<C-r><C-o>z?<Esc>
"xnoremap <Plug>(surround)<Space> "zc<Space><C-r><C-o>z<Space><Esc>
"xnoremap <Plug>(surround)<CR> "zc<CR><C-r><C-o>z<CR><Esc>

" 囲んでいる括弧を削除する
function! s:dsurround () abort
  let c = getcharstr ()
  " 制御文字(0x80で始まる)と<Esc>はなにもしない
  if c[0] ==# "\x80" || c ==# "\<Esc>"
    return ""
  endif

  " クォートはaではなく2iで囲む
  " 参考: help i"
  let tos = c =~# '\v["''`]' ? "2i" : "a"

  if c =~# '\v[bB(){}[\]<>"''`/]'
    return "\"zc" . tos . c . "\<C-r>=substitute (@z, '\\v^.|.$', '', 'g')\<CR>\<Esc>"
  else
    return ""
  endif
endfunction

" nmap ds <Plug>(dsurround)
nnoremap <expr> ds <SID>dsurround ()
" ()
" nnoremap <Plug>(dsurround)b "zcab<C-r>=<SID>dsurround(@z)<CR><Esc>
" nnoremap <Plug>(dsurround)( "zca(<C-r>=<SID>dsurround(@z)<CR><Esc>
" nmap <Plug>(dsurround)) <Plug>(dsurround)(
" " {}
" nnoremap <Plug>(dsurround){ "zca{<C-r>=<SID>dsurround(@z)<CR><Esc>
" nmap <Plug>(dsurround)} <Plug>(dsurround){
" " []
" nnoremap <Plug>(dsurround)[ "zca[<C-r>=<SID>dsurround(@z)<CR><Esc>
" nmap <Plug>(dsurround)] <Plug>(dsurround)[
" " <>
" nnoremap <Plug>(dsurround)< "zca<<C-r>=<SID>dsurround(@z)<CR><Esc>
" nmap <Plug>(dsurround)> <Plug>(dsurround)<
" " ""
" nnoremap <Plug>(dsurround)" "zca"<C-r>=<SID>dsurround(@z)<CR><Esc>
" " ''
" nnoremap <Plug>(dsurround)' "zca'<C-r>=<SID>dsurround(@z)<CR><Esc>
" " ``
" nnoremap <Plug>(dsurround)` "zca`<C-r>=<SID>dsurround(@z)<CR><Esc>
" " //
" nnoremap <Plug>(dsurround)/ "zca/<C-r>=<SID>dsurround(@z)<CR><Esc>


" --------------------------------
"  command mode
" --------------------------------
" NOTICE: cnoremapでは<silent>をつけると描画が反映されなくて困るのでつけないように。

" 補完メニューが表示されているときの挙動修正
" <C-]>はabbrevの展開 :help c_CTRL-]
cnoremap <expr> <CR> wildmenumode () ? '<End>' : (getcmdtype () ==# ':' && getcmdline () ==# '') ? '<BS>' : '<C-]><CR>'
cnoremap <expr> <Left> wildmenumode () ? '<End>' : '<Left>'
cnoremap <expr> <Right> wildmenumode () ? '<End>' : '<Right>'

" Better <C-n>/<C-p> in Command
cnoremap <expr> <C-p> wildmenumode () ? '<C-p>' : '<Up>'
cnoremap <expr> <C-n> wildmenumode () ? '<C-n>' : '<Down>'

cnoremap <expr> <Up> wildmenumode () ? '<C-p>' : '<Up>'
cnoremap <expr> <Down> wildmenumode () ? '<C-n>' : '<Down>'

" <Del>でコマンドラインモードを終了しない
cnoremap <expr> <Del> strpart (getcmdline (), getcmdpos () - 1) ==# '' ? '' : my_pairs#keymapping_right_or_delete ('<Del>')
function! s:cmdline_ctrl_delete () abort
  let pos = getcmdpos ()
  return "\<C-Right>\<Cmd>call setcmdline (strpart (getcmdline (), 0, " . (pos - 1) . ") . strpart (getcmdline (), getcmdpos () - 1), " . pos . ")\<CR>"
endfunction
cnoremap <expr> <C-Del> <SID>cmdline_ctrl_delete ()

" 変わったかどうかが分かりづらいので無効にしておく
cnoremap <Insert> <Nop>

cnoremap <C-f> <Nop>

" 未入力+<Tab>でHistory:を起動(fzf)
cnoremap <expr> <Tab> wildmenumode () ? '<Tab>' : (getcmdtype () ==# ':' && getcmdline () ==# '') ? '<C-u><Esc><Cmd>Telescope command_history<CR>' : (getcmdtype () ==# '/' && getcmdline () ==# '') ? '<C-u><Esc><Cmd>Telescope search_history<CR>' : '<Tab>'

" 自動エスケープ
" 参考 :help search-offset
cnoremap <expr> / getcmdtype () ==# '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype () ==# '?' ? '\?' : '?'

" my_pairs
cnoremap <expr> ( my_pairs#keymapping_pair ('(', ')')
cnoremap <expr> ) my_pairs#keymapping_pair (')', '')
cnoremap <expr> { my_pairs#keymapping_pair ('{', '}')
cnoremap <expr> } my_pairs#keymapping_pair ('}', '')
cnoremap <expr> [ my_pairs#keymapping_pair ('[', ']')
cnoremap <expr> ] my_pairs#keymapping_pair (']', '')

" クォーテーションの自動補完
cnoremap <expr> " my_pairs#keymapping_pair ('"', '"')
cnoremap <expr> ' my_pairs#keymapping_pair ('''', '''')
cnoremap <expr> ` my_pairs#keymapping_pair ('`', '`')

" Space
" Spaceにマッピングを設定するとcabbrevが発動しない…
" cnoremap <expr> <Space> my_pairs#keymapping_open_only ('<Space>', '<Space>')

" arrow
cnoremap <Left> <Cmd>call my_pairs#clear_stack ()<CR><Left>
" cnoremap <expr> <Right> <SID>keymapping_right_or_delete ('<Right>', '<Right>')
" cnoremap <expr> <Right> my_pairs#match_stack (strpart (getcmdline (), getcmdpos () - 1)) ? repeat ('<Right>', strchars (my_pairs#pop_stack
cnoremap <expr> <Right> my_pairs#keymapping_right_or_delete ('<Right>')

" Backspace
cnoremap <expr> <BS> my_pairs#keymapping_backspace ('<BS>')

" function! s:getcmdline () abort
"   let str = getcmdline ()
"   let pos = getcmdpos () - 1
"   let prev = strpart (str, 0, pos)
"   let post = strpart (str, pos)
"   return [prev, post]
" endfunction

" function! s:keymapping_pair (key, end) abort
"   let [prev, post] = s:getcmdline ()
"   return my_pairs#keymapping_pair (prev, post, a:key, a:end)
" endfunction

" function! s:keymapping_open_only (key, end) abort
"   let [prev, post] = s:getcmdline ()
"   return my_pairs#keymapping_open_only (prev, post, a:key, a:end)
" endfunction

" function! s:keymapping_backspace (key) abort
"   let [prev, post] = s:getcmdline ()
"   return my_pairs#keymapping_backspace (prev, post, a:key)
" endfunction


" --------------------------------
"  Terminal
" --------------------------------

" ターミナル内で<Esc>を押したいときが多いのでよくない
"tnoremap <Esc><Esc> <C-\><C-n>

" クリックでterminal windowを選択時にnormalモードに戻らないようにする
tnoremap <LeftMouse> <LeftMouse><Cmd>if &buftype ==# 'terminal'<bar>startinsert<bar>endif<CR>
tnoremap <LeftRelease> <Nop>
tnoremap <2-LeftMouse> <Nop>
tnoremap <3-LeftMouse> <Nop>
tnoremap <4-LeftMouse> <Nop>

" 中クリックで貼り付け
tnoremap <MiddleMouse> <C-\><C-n>pi
tnoremap <MiddleRelease> <Nop>

" ウインドウ切り替え用
" tmap <C-w> <C-\><C-n><C-w>

" {{{
function! s:toggle_netrw () abort
  let exists_netrw = 0
  for i in range (1, bufnr ('$'))
    if getbufvar (i, '&filetype') == 'netrw'
      execute 'bwipeout' i
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


