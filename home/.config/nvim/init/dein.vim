" *******************************
" **  dein.vim
" *******************************
" deinにはpluginをmergeしてruntimepathを短くする機能があるが、lazy loadになっているプラグインはこの機能が効かない(なんで！？)ので、
" pluginフォルダ内に重い処理があるプラグインだけlazy loadをしよう。

" *******************************
" **  first setup
" *******************************
let s:dein_directory = $XDG_CACHE_HOME . '/dein'
let s:dein_repo = s:dein_directory . '/repos/github.com/Shougo/dein.vim'

" install dein.vim automatically
if ! isdirectory (s:dein_repo)
  " call system ('curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh | sh -s -- ' . s:dein_directory)
  call system ('git clone --depth=1 https://github.com/Shougo/dein.vim ' . s:dein_repo)
endif

" Add the dein installation directory into runtimepath
let &runtimepath = &runtimepath . ',' . s:dein_repo

" *******************************
" **  define
" *******************************
if dein#load_state (s:dein_directory)
  " dein#begin 内部で自動的に`filetype off`されるため手動でやる必要はない
  call dein#begin (s:dein_directory, [expand ('<sfile>')])
  " ********************************
  " ** required
  " ********************************
  " dein.vim
  call dein#add (s:dein_repo)

  " ********************************
  " ** workaround for bug
  " ********************************
  " fix https://github.com/neovim/neovim/issues/12587
  call dein#add ('antoinemadec/FixCursorHold.nvim')

  " fix https://github.com/neovim/neovim/issues/1716
  call dein#add ('lambdalisue/suda.vim')

  " ********************************
  " ** improve default behavior
  " ********************************
  " fern
  call dein#add ('lambdalisue/fern.vim', #{hook_add: 'let g:fern#default_hidden = 1'})

  " netrw hijack (requires fern.vim)
  call dein#add ('lambdalisue/fern-hijack.vim')

  " toggle comment
  " autocmdをつかってくれ
  call dein#add ('tpope/vim-commentary', #{on_event: 'VimEnter', hook_post_source: 'call plugin#commentary#init ()'})

  " ********************************
  " ** plugins
  " ********************************
  " LSP client
  " call dein#add ('neoclide/coc.nvim', {'merged': v:false, 'rev': 'release', 'on_event': 'VimEnter', 'hook_source': 'call plugin#coc#init ()'})
  call dein#add ('neovim/nvim-lspconfig')
  call dein#add ('williamboman/mason.nvim')
  call dein#add ('williamboman/mason-lspconfig.nvim', #{hook_add: 'lua require "init/lsp"'})

  " show git diff at SignColumn
  " call dein#add ('airblade/vim-gitgutter', {'on_event': 'VimEnter', 'hook_add': 'let g:gitgutter_map_keys = 0'})
  call dein#add ('lewis6991/gitsigns.nvim', #{hook_post_source: 'lua require "gitsigns".setup { signs = { add = { text = "+" }, change = { text = "~" } }, attach_to_untracked = false }'})

  " customize statusline
  " call dein#add ('itchyny/lightline.vim', {'hook_add': 'call plugin#lightline#init ()'})
  call dein#add ('nvim-lualine/lualine.nvim')


  " lightlineにcoc情報を表示する関数を提供する
  " call dein#add ('josa42/vim-lightline-coc')

  " fzf
  call dein#add ('junegunn/fzf.vim', #{on_event: 'VimEnter', hook_post_source: 'call plugin#fzf#init ()', hook_add: 'if filereadable (expand ("~/.fzf/plugin/fzf.vim")) | set rtp+=~/.fzf/ | endif'})

  " ********************************
  " ** denops plugins
  " ********************************
  " ecosystem of Vim/Neovim which allows developers to write cross-platform plugins in Deno
  call dein#add ('vim-denops/denops.vim')

  " GhostText
  call dein#add ('gamoutatsumi/dps-ghosttext.vim')

  " Preview markdown on your browser
  call dein#add ('kat0h/bufpreview.vim', #{build: 'deno task prepare'})

  " ********************************
  " ** ddc plugins
  " ********************************
  " original popup menu completion
  call dein#add ('Shougo/pum.vim')

  " completion framework
  call dein#add ('Shougo/ddc.vim', #{on_event: 'InsertEnter', hook_source: 'call plugin#ddc#init ()'})

  " UI
  call dein#add ('Shougo/ddc-ui-native')

  " ddc source
  " nvim-lsp
  call dein#add ('Shougo/ddc-nvim-lsp')
  " around cursor
  call dein#add ('Shougo/ddc-around')
  " skkeleton
  call dein#add ('vim-skk/skkeleton', #{hook_post_source: 'call plugin#skkeleton#init ()'})

  " matcher
  call dein#add ('tani/ddc-fuzzy')
  " call dein#add ('Shougo/ddc-matcher_head')

  " sorter
  " call dein#add ('Shougo/ddc-sorter_rank')

  " ********************************
  " ** lua plugins
  " ********************************
  " virtual text を利用したindent guide. No conceal らしいので採用
  call dein#add ('lukas-reineke/indent-blankline.nvim', #{hook_post_source: 'lua require "init/indent-blankline"'})

  " 通知をいい感じにする
  call dein#add ("rcarriga/nvim-notify", #{hook_add: 'lua require "init/nvim-notify"'})


  " ********************************
  " ** treesitter
  " ********************************
  " buildしたものが入るためmergeできない
  call dein#add ('nvim-treesitter/nvim-treesitter', #{merged: v:false, hook_post_source: 'lua require "init/nvim-treesitter"'})

  " TSCaptureUnderCursorのため→ いらなくなった！
  " call dein#add ('nvim-treesitter/playground')

  " textobject
  call dein#add ('nvim-treesitter/nvim-treesitter-textobjects')

  " colorize parens
  " call dein#add ('p00f/nvim-ts-rainbow', {'depends': ['nvim-treesitter']})


  " ********************************
  " ** ftplugin
  " ** ftdetect, ftplugin, syntax定義のみ
  " ********************************
  " colorize color code
  " なんか動いてなさそう？
  " call dein#add ('gorodinskiy/vim-coloresque')
  call dein#add ('norcalli/nvim-colorizer.lua', #{hook_post_source: 'lua require "colorizer".setup ()'})

  " C++
  "call dein#add ('octol/vim-cpp-enhanced-highlight')

  " fish shell script
  "call dein#add ('dag/vim-fish')

  " ********************************
  " ** indent
  " ********************************
  " javascript, typescript
  " 微妙だったので無効化
  " call dein#add ('jason0x43/vim-js-indent')

  " ********************************
  " ** end
  " ********************************
  call dein#end ()
  call dein#save_state ()
endif

" ********************************
" ** lazy
" ********************************
if has ('vim_starting')
  augroup init-dein-check-install
    autocmd!
    autocmd VimEnter * ++once call s:onVimEnter ()
  augroup END
else
  " call s:onVimEnter ()
endif

function! s:onVimEnter () "noabort
  " call lightline#update ()

  " NOTE: In Vim initializing, you must call the
  " hook_post_source" hooks manually in |VimEnter| if needed.
  call dein#call_hook ('post_source')

  if dein#check_install ()
    call dein#install ()
  endif
  silent call plugin#dein#check_and_uninstall ()
endfunction
