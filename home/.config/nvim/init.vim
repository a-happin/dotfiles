set encoding=utf-8
scriptencoding utf-8


" *******************************
" **  env
" *******************************

if empty ($XDG_CONFIG_HOME)
  let $XDG_CONFIG_HOME = $HOME . '/.config'
endif

if empty ($XDG_CACHE_HOME)
  let $XDG_CACHE_HOME = $HOME . '/.cache'
endif

if empty ($XDG_DATA_HOME)
  let $XDG_DATA_HOME = $HOME . '/.local/share'
endif


" *******************************
" **  minpac
" *******************************

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

  packadd encrypt
  packadd vim-fish

else
  call system ('git clone --depth 1 https://github.com/k-takata/minpac.git ' . s:minpac_dir . '/pack/minpac/opt/minpac')
  call pack#init ()
  call minpac#update ()
endif

packadd mappings

" *******************************
" **  command
" *******************************

" minpac
command! -bar PackInit call pack#init ()
command! -bar PackUpdate call pack#init () | call minpac#update ()
command! -bar PackClean call pack#init () | call minpac#clean ()

command! -bar Reload source ${MYVIMRC}

" terminal
command! -nargs=* -complete=shellcmd Hterminal botright split new | resize 20 | terminal <args>
command! -nargs=* -complete=shellcmd Vterminal botright vertical new | terminal <args>
command! -nargs=* -complete=shellcmd Tterminal tabnew | terminal <args>

command! -bar GitHub call util#open ('https://github.com/' . expand ('<cfile>'))

" カーソル位置のsyntax hightlight group
command! -bar CurrentSyntax echo synIDattr(synID(line('.'), col('.'), 1), 'name')

" session
command! -bar -nargs=1 SaveSession call mkdir ($XDG_DATA_HOME . '/nvim/sessions', 'p') | mksession! $XDG_DATA_HOME/nvim/sessions/<args>.vim
command! -bar -nargs=1 LoadSession source $XDG_DATA_HOME/nvim/sessions/<args>.vim

" 最後に保存してからのdiff
command! -bar DiffOrig aboveleft vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis | wincmd p | diffthis



" typo対策
cnoreabbrev <expr> W (getcmdtype () ==# ":" && getcmdline () ==# "W") ? "w" : "W"

" root権限に昇格して書き込み
" neovimでは機能しない https://github.com/neovim/neovim/issues/8217 ←won't fix……
cnoreabbrev <expr> w!! (getcmdtype () ==# ":" && getcmdline () ==# "w!!") ? "w !sudo tee > /dev/null %" : "w!!"


" *******************************
" **  (v'-')っ First Initialize
" *******************************

filetype plugin indent on
syntax enable


" *******************************
" **  settings
" *******************************

" 上のヘルプコメントを隠す
let g:netrw_banner = 0
" tree形式で表示
let g:netrw_liststyle = 3
" サイズ表示を1024baseなK,M,G表記にする
let g:netrw_sizestyle = "H"
" 左右分割を右側に開く
let g:netrw_altv = 1

" jsonのconcealを無効にする
" 今はconceal自体を無効化しているのでコメントアウト
" let g:vim_json_conceal = 0


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

" Cのインデントオプション
" :0 Labelのインデントを深くしない
" g0 アクセス修飾子のインデントを深くしない
" t0 templateのインデントを深くしない
" +0 namespace内、クラス内のtemplateのインデントを深くしない
set cinoptions& cinoptions+=:0,g0,t0,+0

" share clipboard
if has('unnamedplus')
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

" if 0, disable c
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

" show status line
" if 2, always
set laststatus=2

" 空白文字の可視化
" visualize space character
set list

" set listで表示する文字
set listchars=tab:»\ ,trail:_,nbsp:%

" 括弧の対応
set matchpairs=(:),{:},[:],<:>

" showmatchのジャンプ時間(1 = 0.1sec)
"set matchtime=2

" enable mouse
" 'a' means enable in all mode
set mouse=ar

" show line number
set number

"
"set omnifunc=

" インデントを減らそうとした時、すでに存在するインデント構造を破壊しない
" ただし、インデントを増やした場合はTabとspaceの混合になるので注意
set preserveindent

" 補完メニューの高さを制限する
" if 0, スペースいっぱい使う
set pumheight=25

" Enables pseudo-transparency for the |popup-menu|. Valid values are in
" the range of 0 for fully opaque popupmenu (disabled) to 100 for fully
" transparent background. Values between 0-30 are typically most useful.
" 半透明描画ができないターミナルだと全部透過されて残念な見た目になる…。
set pumblend=0

" 相対行番号
"set relativenumber

" show position of cursor
set ruler

" session保存時に保存する情報
set sessionoptions& sessionoptions+=resize

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

" 現在の入力モードを表示しない(プラグインでstatuslineに表示するようにしたので)
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
set statusline=%F\ %m%r%h%w%=[FORMAT=%{&ff}]\ %y\ (%3v,%3l)\ [%2p%%]

" do not create swap file
set noswapfile

set tabline=%!tabline#make()

" tab width
set tabstop=8

" Time in milliseconds to wait for a mapped sequence to complete.
set timeoutlen=2000

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

" wrap
set wrap

" search loop
set wrapscan

" Make a backup before overwriting a file.
set nowritebackup


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
  colorscheme pink-theme
catch /:E185:/
endtry

" highlight Normal ctermbg=none
" highlight CursorLineNr ctermfg=15


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
  autocmd BufWritePost */.config/nvim/* ++nested source $MYVIMRC | redraw | echomsg 'Reloaded' $MYVIMRC
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
  autocmd InsertEnter,FocusGained * checktime
augroup END

augroup template
  autocmd!
  autocmd BufNewFile *.* silent! 0r $XDG_CONFIG_HOME/nvim/template/.%:e
augroup END

augroup fix-terminal
  autocmd!
  autocmd TermOpen term://* setlocal nonumber bufhidden=wipe
  autocmd TermOpen,TermEnter,WinEnter term://* startinsert
  autocmd TermClose term://* stopinsert | setlocal readonly
  autocmd TermClose term://*/bash,term://*/fish,term://*/zsh bwipeout!
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

augroup set-force
  autocmd!
  autocmd FileType * setlocal formatoptions& formatoptions-=t formatoptions-=c formatoptions-=r formatoptions-=o formatoptions+=M iskeyword-=# iskeyword-=/
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
