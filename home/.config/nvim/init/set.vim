" *******************************
" **  set
" *******************************

" width of EAW
"set ambiwidth=double

" audoindent
set autoindent

" 編集中のファイルが外部で変更されたらそれを自動で読み込む
set autoread

" set background dark
" ※注意: ここでcolorschemeがリロードされるのでこれ以前のhighlightコマンドは上書きされる
set background=dark

" enable Backspace to delete 'auto indent', EOL, and start
set backspace=indent,eol,start

" don't create backup file
set nobackup

" :  :で自動インデントしない
" 0# 行頭の#で自動インデントしない
" e  elseで自動インデントしない
set cinkeys& cinkeys-=: cinkeys-=0# cinkeys-=e

" Cのインデントオプション
" :0 Labelのインデントを深くしない
" g0 アクセス修飾子のインデントを深くしない
" t0 templateのインデントを深くしない
" +0 namespace内、クラス内のtemplateのインデントを深くしない
" (0 括弧が閉じていないとき、閉じていない括弧からのインデント量を0にする
" Ws (0指定時に閉じていない括弧からではなく非空白文字からのインデント量をshiftwidthにする
" m1 括弧閉じのインデントを浅くする(?)
set cinoptions& cinoptions+=:0,g0,t0,+0,(0,Ws,m1

" share clipboard
if has ('unnamedplus')
  set clipboard=unnamedplus,unnamed
else
  set clipboard=unnamed
endif

" 補完の種類
set complete=.,w,b,u,k,s,i,d,t

" ユーザ定義補完関数
"set completefunc=

" completion option
" menuone: use popup menu even though there is only one match.
" preview: show extra information
" noinsert: do not insert until select
" noselect: do not select
"set completeopt=menuone,preview,noinsert
set completeopt=menuone,preview,noselect

" concealを有効にするモード
" n: normal
" v: visual (not recommend)
" i: insert (not recommend)
" c: command line editing
set concealcursor=nc

" if 0, disable conceal
" 表示するなら2かな
" 起動時の:introがなくなってしまうことに気づいて、寂しいので無効化する……。
set conceallevel=0

" 保存せずに終了しようとした時に確認を行う
set confirm

" 既存行のインデント構造をコピーする
" Tab文字で構成されている場合は新しい行のインデントもTab文字で構成する
set copyindent

" show cursor column
" show cursor line
set nocursorcolumn nocursorline

" dictionary
"set dictionary=

" replace Tab with spaces
set expandtab

" End of Bufferの~を非表示にする
set fillchars& fillchars+=eob:\ 

" 勝手にwrapしない
" 行コメントを自動で継続しない
" 日本語でjoin時に空白を入れない
set formatoptions& formatoptions-=t formatoptions-=c formatoptions-=r formatoptions-=o formatoptions+=M

" :bでバッファを切り替えるときに保存しなくてもよくなる
set hidden

set nohlsearch

" 検索時に大文字と小文字を区別しない
set ignorecase

" 置き換え時にプレビュー表示
set inccommand=split

" 入力中に検索を開始する
set incsearch

" キーワード (\k)
" @はアルファベットを表す
" ハイフン(-)もキーワードとみなす
" @自体を追加したい場合は@-@とする(範囲指定)
set iskeyword& iskeyword+=-

" Special keysを押したときにvisual modeに移行する
" Special keys: 矢印, <Home>, <End>, <Pageup>, <PageDown>
set keymodel=startsel

" show status line
" if 2, always
" if 3, global status line
set laststatus=3

" 空白文字の可視化
" visualize space character
set list

" set listで表示する文字
set listchars=tab:»\ ,trail:_,nbsp:%

" 括弧の対応
set matchpairs=(:),{:},[:],<:>,「:」,『:』,（:）,【:】,《:》,〈:〉,［:］,‘:’,“:”

" showmatchのジャンプ時間(1 = 0.1sec)
"set matchtime=2

" enable mouse
" 'a' means enable in all mode
set mouse=ar

" 有効にしたいけど壊れてる
" set mousefocus

" set mousemodel=popup_setpos
" mousemodel=popup_setposにしつつ、popup menuを無効にすることでsetposだけにする
aunmenu PopUp

" ホイールのスクロール量
" default=ver:3,hor:6
set mousescroll=ver:5,hor:6

" show line number
set number

"
"set omnifunc=

" インデントを減らそうとした時、すでに存在するインデント構造を破壊しない
" ただし、インデントを増やした場合はTabとspaceの混合になるので注意
set preserveindent

" 補完メニューの高さを制限する
" if 0, スペースいっぱい使う
set pumheight=100

" Enables pseudo-transparency for the |popup-menu|. Valid values are in
" the range of 0 for fully opaque popupmenu (disabled) to 100 for fully
" transparent background. Values between 0-30 are typically most useful.
" 半透明描画ができないターミナルだと全部透過されて残念な見た目になる…。
set pumblend=0

" 相対行番号
"set relativenumber

" show position of cursor
set ruler

" old: inclusiveかつ改行を選択しない
set selection=old

" visual modeに移行したときに自動的にselect modeに移行する
" mouse: マウスを使ったとき
" key: Special Keysを押したとき -- Special keys: 矢印, <Home>, <End>, <PageUp>, <PageDown>
" cmd: v, V or <C-v>を押したとき
" set selectmode=

" session保存時に保存する情報
set sessionoptions& sessionoptions+=localoptions,resize

" 環境変数SHELLから自動で設定されるので設定の必要なし
" set shell=fish

" <>などでインデント調整時にshiftwidthの倍数に丸める
set shiftround

" indent width
" if 0, the same as tabstop.
set shiftwidth=2

" c: don't give |ins-completion-menu| messages.
set shortmess& shortmess+=c

" display inputting command on lower right
set showcmd

" 現在の入力モードを表示する(プラグインでstatuslineに表示するようにしたが、プラグインがバグると困るので…)
set showmode

" 括弧入力時に対応する括弧に一瞬ジャンプしない（うざい）
set noshowmatch

" 大文字で検索した時は大文字と小文字を区別する
set smartcase

" 行頭のTabはshiftwidthに、それ以外はtabstopまたはsofttabstopに従う
set smartindent

" かしこい
set smarttab

" Tab幅がsofttabstopであるかのように見えるようになる
" Tabを押した時にsofttabstopの幅だけspacesを挿入する
" Backspaceでsofttabstopの幅だけspacesを削除する
" if 0, disable this feature
" if negative, the same as shiftwidth
set softtabstop=0

" enable spell check
"set spell

" 日本語をスペルチェック対象外にする
set spelllang=en,cjk

" 分割した時に下側に新しいウインドウを表示
"set splitbelow

" 分割した時に右側に新しいウインドウを表示
set splitright

" format of status line
let s:mode_color = {
  \ 'n': 'guifg=#242b38 guibg=#59c2ff',
  \ '': '',
\}
let s:mode_str = {
  \ 'n'      : 'NORMAL',
  \ 'no'     : 'O-PENDING',
  \ 'nov'    : 'O-PENDING',
  \ 'noV'    : 'O-PENDING',
  \ 'no\22'  : 'O-PENDING',
  \ 'niI'    : 'NORMAL',
  \ 'niR'    : 'NORMAL',
  \ 'niV'    : 'NORMAL',
  \ 'nt'     : 'NORMAL',
  \ 'ntT'    : 'NORMAL',
  \ 'v'      : 'VISUAL',
  \ 'vs'     : 'VISUAL',
  \ 'V'      : 'V-LINE',
  \ 'Vs'     : 'V-LINE',
  \ '\22'    : 'V-BLOCK',
  \ '\22s'   : 'V-BLOCK',
  \ 's'      : 'SELECT',
  \ 'S'      : 'S-LINE',
  \ '\19'    : 'S-BLOCK',
  \ 'i'      : 'INSERT',
  \ 'ic'     : 'INSERT',
  \ 'ix'     : 'INSERT',
  \ 'R'      : 'REPLACE',
  \ 'Rc'     : 'REPLACE',
  \ 'Rx'     : 'REPLACE',
  \ 'Rv'     : 'V-REPLACE',
  \ 'Rvc'    : 'V-REPLACE',
  \ 'Rvx'    : 'V-REPLACE',
  \ 'c'      : 'COMMAND',
  \ 'cv'     : 'EX',
  \ 'ce'     : 'EX',
  \ 'r'      : 'REPLACE',
  \ 'rm'     : 'MORE',
  \ 'r?'     : 'CONFIRM',
  \ '!'      : 'SHELL',
  \ 't'      : 'TERMINAL',
\}
let s:mode_color_map = {
  \ 'VISUAL' : '_visual',
  \ 'V-BLOCK' : '_visual',
  \ 'V-LINE' : '_visual',
  \ 'SELECT' : '_visual',
  \ 'S-LINE' : '_visual',
  \ 'S-BLOCK' : '_visual',
  \ 'REPLACE' : '_replace',
  \ 'V-REPLACE' : '_replace',
  \ 'INSERT' : '_insert',
  \ 'COMMAND' : '_command',
  \ 'EX' : '_command',
  \ 'MORE' : '_command',
  \ 'CONFIRM' : '_command',
  \ 'TERMINAL' : '_terminal',
\}
let s:mode_color_map2 = {
  \ '_visual': { 'ctermfg': '234', 'guifg':'#242b38', 'ctermbg':'12', 'guibg':'#d4bfff' },
  \ '_replace': { 'ctermfg': '234', 'guifg':'#242b38', 'ctermbg':'12', 'guibg':'#f07178' },
  \ '_normal': { 'ctermfg': '234', 'guifg':'#242b38', 'ctermbg':'12', 'guibg':'#59c2ff' },
  \ '_command': { 'ctermfg': '234', 'guifg':'#242b38', 'ctermbg':'12', 'guibg':'#59c2ff' },
  \ '_insert': { 'ctermfg': '234', 'guifg':'#242b38', 'ctermbg':'12', 'guibg':'#bbe67e' },
  \ '_terminal': { 'ctermfg': '234', 'guifg':'#242b38', 'ctermbg':'12', 'guibg':'#bbe67e' },
\}
let s:fileformat_map = {
  \ 'unix': 'LF',
  \ 'dos' : 'CRLF',
  \ 'mac' : 'CR',
\}
function! StatusLine() abort
  let m = mode ()
  let mode_str = get (s:mode_str, m, m)
  let color = get(s:mode_color_map2, get(s:mode_color_map, mode_str, '_normal'), '')
  execute 'highlight StatusLineA cterm=bold gui=bold ctermfg=' . color['ctermfg'] 'ctermbg=' . color['ctermbg'] 'guifg=' . color['guifg'] 'guibg=' . color['guibg']
  " highlight StatusLine cterm=none ctermfg=254 ctermbg=234 gui=none guifg=#d9d7ce guibg=#272d38
  execute 'highlight StatusLineSep ctermbg=234 guibg=#272d38' 'ctermfg=' . color['ctermbg'] 'guifg=' . color['guibg']
  return '%#StatusLineA# ' . mode_str . ' %#StatusLineSep#%#StatusLine# %f %m%r%h%w%=' . '%{&filetype} %#StatusLineSep#%#StatusLineA# ' . get(s:fileformat_map, &fileformat, '?') . '  %{&fileencoding}%{&binary ? "binary" : ""}  %3l,%-2v '
endfunction
" set statusline=%F\ %m%r%h%w%=[FORMAT=%{&ff}]\ %y\ (%3l,%-2v)\ [%2p%%]
set statusline=%!StatusLine()

" do not create swap file
set noswapfile

set tabline=%!tabline#make()

" 同時に開けるタブ数(未調査)
set tabpagemax=50

" tab width
set tabstop=8

" pumblend requires termguicolors
if $TERM !=# 'rxvt-unicode-256color'
  set termguicolors
  set pumblend=15
endif

" Time in milliseconds to wait for a mapped sequence to complete.
set timeoutlen=2000

if has('persistent_undo') && &undodir !=# ''
  " dirの方はデフォルトでセットされているのでなにもしなくていい
  " set undodir
  call mkdir (&undodir, 'p', 0700)

  " undo履歴をファイルに保存する(ファイル名を変更した場合は履歴が失われる(らしい)ので注意)
  set undofile
endif

" CursorHoldの発動ラグ
set updatetime=300

" 移動キーなどで行をまたいで移動する
" b: <BS>
" s: <Space>
" <: <Left>
" >: <Right>
" [: <Left> in insert mode
" ]: <Right> in insert mode
set whichwrap=

" charater which starts completion in command line
set wildchar=<Tab>

" マクロとkeymapping時に<Tab>を押すとwildmenu表示
set wildcharm=<Tab>

" When set case is ignored when completing file names and directories.
set wildignorecase

" display wild command completion
set wildmenu

" 最初のTabでwildmenuを出す
" 次のTabからmatchを補完する
set wildmode=longest:full,full

set wildoptions=fuzzy,pum,tagfile

" wrap
set wrap

" search loop
set wrapscan

" Make a backup before overwriting a file.
set nowritebackup
