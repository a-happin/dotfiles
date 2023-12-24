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

function! s:noxnoremap (lhs, rhs) "noabort
  execute 'noremap' a:lhs a:rhs
  execute 'sunmap' a:lhs
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

" TODO: 後で変える
nnoremap <F5> <Cmd>Vterminal cargo test<CR>

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
call s:nxnoremap ('fj', 'f<C-k>j')
call s:nxnoremap ('fz', 'f<C-k>z')
call s:nxnoremap ('Fj', 'F<C-k>j')
call s:nxnoremap ('Fz', 'F<C-k>z')
call s:nxnoremap ('tj', 't<C-k>j')
call s:nxnoremap ('tz', 't<C-k>z')
call s:nxnoremap ('Tj', 'T<C-k>j')
call s:nxnoremap ('Tz', 'T<C-k>z')


" --------------------------------
"  コマンド/オペレータ系[Normal]
" --------------------------------

" Shift-Yで行末までヤンク
" デフォルトがこれになったとかなんとか
nnoremap Y y$

" ファイルチェックして再描画！
" nnoremap <C-l> <Cmd>checktime<CR><C-l>

" Shift-Tabでインデントを1つ減らす
"nnoremap <S-Tab> <<

" <Tab>でtab切り替え
nnoremap <Tab> gt
nnoremap <S-Tab> gT
nnoremap <C-w><Tab> gt
nnoremap <C-w><S-Tab> gT

" nnoremap f<CR> $

" nnoremap <F5> <Cmd>call system('deno run --allow-all ./generator.ts > fantasy.vim')\|Reload<CR>

" nnoremap <BS> <C-o>


" --------------------------------
"  コマンド/オペレータ系[Visual]
" --------------------------------
" 選択範囲をヤンクした文字列で上書き時にレジスタを汚さない
" xnoremap p pgvy
" xnoremap p "_xP
xnoremap <expr> p 'pgv"' . v:register . 'y`>'

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
call s:noxnoremap ('<expr> j', 'v:count > 0 ? "j" : "gj"')
call s:noxnoremap ('<expr> k', 'v:count > 0 ? "k" : "gk"')
noremap <expr> <Down> v:count > 0 ? 'j' : 'gj'
noremap <expr> <Up>   v:count > 0 ? 'k' : 'gk'

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
inoremap <silent> <expr> <Home> '<C-o>' . (strpart (getline ('.'), 0, col ('.') - 1) =~# '\v^\s+$' ? "0" : "^")

" exclusive <End>
noremap <expr> <End> &selection ==# 'inclusive' ? '<End><Left>' : '<End>'
nunmap <End>
noremap <expr> <S-End> &selection ==# 'inclusive' ? '<S-End><Left>' : '<S-End>'

" <C-End>でinclusiveな<End>ができるようにする
noremap <C-End> <End>
noremap <C-S-End> <S-End>

" うわ急に飛ぶな
noremap <C-Home> <Home>
noremap <C-S-Home> <S-Home>
noremap <PageUp> <C-y>
noremap <S-PageUp> <C-y>
noremap <PageDown> <C-e>
noremap <S-PageDown> <C-e>

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


" --------------------------------
"  Alt key mappings
" --------------------------------

" 全部閉じて終了
"call s:anoremap ('<M-Q>', '<Cmd>confirm qall<CR>')
call s:anoremap ('<M-q>', '<Cmd>confirm qall<CR>')
"call s:anoremap ('<M-q>', '<Cmd>confirm q<CR>')

nmap <M-w> <C-w>

" Open File Explorer
" nnoremap <C-e> <Cmd>call <SID>toggle_netrw ()<CR>
call s:anoremap ('<M-e>', '<Cmd>Fern . -reveal=% -drawer -toggle<CR>')

" Reload init.vim
nnoremap <M-r> <Cmd>source $MYVIMRC<CR>

" Toggle Terminal
nnoremap <M-t> <Cmd>Hterminal<CR>
call s:anoremap ('<M-CR>', '<Cmd>ToggleTerminal<CR>')

" LoadSession if current buffer is empty and it's the only buffer
" SaveSession if others
call s:anoremap ('<M-s>', '<Cmd>if bufnr ("$") ==# 1 && &modified ==# 0 && empty (&buftype)<bar>LoadSession default<bar>else<bar>SaveSession default<bar>endif<CR>')

call s:anoremap ('<M-h>', '<Cmd>wincmd h<CR>')
call s:anoremap ('<M-j>', '<Cmd>wincmd j<CR>')
call s:anoremap ('<M-k>', '<Cmd>wincmd k<CR>')
call s:anoremap ('<M-l>', '<Cmd>wincmd l<CR>')
call s:anoremap ('<M-H>', '<Cmd>wincmd H<CR>')
call s:anoremap ('<M-J>', '<Cmd>wincmd J<CR>')
call s:anoremap ('<M-K>', '<Cmd>wincmd K<CR>')
call s:anoremap ('<M-L>', '<Cmd>wincmd L<CR>')
call s:anoremap ('<M-T>', '<Cmd>wincmd T<CR>')
call s:anoremap ('<M-->', '<Cmd>resize -1<CR>')
call s:anoremap ('<M-=>', '<Cmd>resize +1<CR>')
call s:anoremap ('<M-<>', '<Cmd>vertical resize -1<CR>')
call s:anoremap ('<M->>', '<Cmd>vertical resize +1<CR>')

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
" noremap <M-Tab> <Cmd>tabnext<CR>
" doesn't work
"noremap <M-S-Tab> <Cmd>tabprev<CR>


" 戻る
nnoremap <M-Left> <C-o>
" 進む
nnoremap <M-Right> <C-i>

" 入れ替え
nnoremap <expr> <M-Up> '<Cmd>move .-' . (v:count > 0 ? v:count + 1 : 2) . '<CR>'
nnoremap <expr> <M-Down> '<Cmd>move .+' . (v:count > 0 ? v:count : 1) . '<CR>'
" 範囲選択での入れ替え
vnoremap <M-Up> :move '<-2<CR>gv
vnoremap <M-Down> :move '>+1<CR>gv

" --------------------------------
"  <Space>
" --------------------------------

nnoremap <Space><Esc> <Nop>

" カーソル下のsyntax highlight表示
nnoremap <Space><F1> <Cmd>Inspect<CR>

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
nnoremap <Space>t <C-w>T

" Copy to clipboard
" call s:nxnoremap ('<Space>y', '"wy')

" 改行挿入
nnoremap <Space>o o<Space><C-u><Esc>
nnoremap <Space>O O<Space><C-u><Esc>

" Paste from clipboard
" call s:nxnoremap ('<Space>p', '<Cmd>GetWindowsClipboard<CR>p')
" call s:nxnoremap ('<Space>P', '<Cmd>GetWindowsClipboard<CR>P')

" Split Horizontally
nnoremap <Space>s <C-w>s

" nnoremap <Space>d lD

" Run FZF
nnoremap <Space>f <Cmd>Files<CR>

" git ls-files | fzf
nnoremap <Space>g <Cmd>GFiles<CR>

" wrap考慮の行頭、行末移動
call s:nxnoremap ('<Space>h', 'g^')
call s:nxnoremap ('<Space>l', 'g$')
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
nnoremap <Space>b <Cmd>Buffers<CR>

" 新規
nnoremap <Space>n <Nop>
nnoremap <Space>nn <Cmd>enew<CR>
nnoremap <Space>ns <Cmd>new<CR>
nnoremap <Space>nv <Cmd>vnew<CR>
nnoremap <Space>n<Tab> <Cmd>tabnew<CR>

" open config file
nnoremap <Space>, <Cmd>tabnew $MYVIMRC \| lcd %:h<CR>

" source this
nnoremap <Space>. <Cmd>if expand ('%:e') ==# 'vim'<bar>source %<bar>echo 'sourced this file'<bar>endif<CR>

" ripgrep
nnoremap <Space>/ <Cmd>Rg<CR>

" 選択中の文字列で検索をかける
xnoremap <Space>/ "sy/\V<C-r>=escape(@s, '\/')<CR><CR><Cmd>call <SID>flash_hlsearch()<CR>


" --------------------------------
"  commentout
" --------------------------------

" Linuxでは<C-/>は<C-_>で設定しないといけないらしい
" プラグインがないとき用の設定
try
  silent nnoremap <unique> <C-_> I//<Space><Esc>
  silent vnoremap <unique> <C-_> I//<Space><Esc>
  silent inoremap <unique> <C-_> <C-g>u<C-o>^//<Space>
catch /:E227:/
endtry

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

    if c =~# '\v[bB(){}[\]<>"''`/]'
      return "\"zca" . c . "\<C-r>=trim (substitute (@z, '\\v^.|.$', '', 'g'))\<CR>\<Esc>"
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
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" <Up><Up>でHistory:を起動(fzf)
" cnoremap <expr> <Up> wildmenumode () ? '<C-p>' : (getcmdtype () ==# ':' && getcmdline () !=# '') ? '<C-u><Esc><Cmd>History:<CR>' : (getcmdtype () ==# '/' && getcmdline () !=# '') ? '<C-u><Esc><Cmd>History/<CR>' : '<C-p>'
" cnoremap <Up> <C-p>
" cnoremap <Down> <C-n>

" 変わったかどうかが分かりづらいので無効にしておく
cnoremap <Insert> <Nop>

" 未入力+<Tab>でHistory:を起動(fzf)
cnoremap <expr> <Tab> wildmenumode () ? '<Tab>' : (getcmdtype () ==# ':' && getcmdline () ==# '') ? '<C-u><Esc><Cmd>History:<CR>' : (getcmdtype () ==# '/' && getcmdline () ==# '') ? '<C-u><Esc><Cmd>History/<CR>' : '<Tab>'

" 自動エスケープ
" 参考 :help search-offset
cnoremap <expr> / getcmdtype () ==# '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype () ==# '?' ? '\?' : '?'


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


