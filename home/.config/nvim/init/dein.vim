scriptencoding utf-8

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
  " call dein#add ('lambdalisue/suda.vim')

  " ********************************
  " ** improve default behavior
  " ********************************
  " fern
  call dein#add ('lambdalisue/fern.vim', {'hook_add': 'let g:fern#default_hidden = 1'})

  " netrw hijack (requires fern.vim)
  call dein#add ('lambdalisue/fern-hijack.vim')

  " toggle comment
  " autocmdをつかってくれ
  call dein#add ('tpope/vim-commentary', {'on_event': 'VimEnter'})

  " ********************************
  " ** plugins
  " ********************************
  " LSP client
  call dein#add ('neoclide/coc.nvim', {'merged': v:false, 'rev': 'release', 'on_event': 'VimEnter', 'hook_source': 'call pack#coc#init ()'})

  " show git diff at SignColumn
  call dein#add ('airblade/vim-gitgutter', {'on_event': 'VimEnter'})

  " customize statusline
  call dein#add ('itchyny/lightline.vim', {'hook_add': 'call pack#lightline#init ()'})

  " lightlineにcoc情報を表示する関数を提供する
  call dein#add ('josa42/vim-lightline-coc')

  " fzf
  call dein#add ('junegunn/fzf.vim', {'on_event': 'VimEnter'})

  " ********************************
  " ** denops plugins
  " ********************************
  " ecosystem of Vim/Neovim which allows developers to write cross-platform plugins in Deno
  call dein#add ('vim-denops/denops.vim')

  " GhostText
  call dein#add ('gamoutatsumi/dps-ghosttext.vim')

  " Preview markdown on your browser
  call dein#add ('kat0h/bufpreview.vim')

  " ********************************
  " ** lua plugins
  " ********************************
  " virtual text を利用したindent guide. No conceal らしいので採用
  " call dein#add ('lukas-reineke/indent-blankline.nvim')

  " ********************************
  " ** ftplugin
  " ** ftdetect, ftplugin, syntax定義のみ
  " ********************************
  " colorize color code
  call dein#add ('gorodinskiy/vim-coloresque')

  " C++
  call dein#add ('octol/vim-cpp-enhanced-highlight')

  " fish shell script
  call dein#add ('dag/vim-fish')

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
  call s:onVimEnter ()
endif

function! s:onVimEnter () "noabort
  " call lightline#update ()
  if dein#check_install ()
    call dein#install ()
  endif
  silent call pack#dein#check_and_uninstall ()
endfunction
