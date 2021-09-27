scriptencoding utf-8

" *******************************
" **  command
" *******************************

" minpac
command! -bar PackInit call pack#init ()
command! -bar PackUpdate call pack#init () | call minpac#update ()
command! -bar PackClean call pack#init () | call minpac#clean ()

command! -bar Reload source ${MYVIMRC}

" terminal
command! -nargs=* -complete=shellcmd Hterminal botright new | resize 20 | terminal <args>
command! -nargs=* -complete=shellcmd Vterminal botright vertical new | terminal <args>
command! -nargs=* -complete=shellcmd Tterminal tabnew | terminal <args>

command! -bar GitHub call open#open ('https://github.com/' . expand ('<cfile>'))

" カーソル位置のsyntax hightlight group
command! -bar CurrentSyntax echo synIDattr(synID(line('.'), col('.'), 1), 'name')

" session
command! -bar -nargs=1 SaveSession call mkdir ($XDG_DATA_HOME . '/nvim/sessions', 'p') | mksession! $XDG_DATA_HOME/nvim/sessions/<args>.vim
command! -bar -nargs=1 LoadSession source $XDG_DATA_HOME/nvim/sessions/<args>.vim

" 最後に保存してからのdiff
command! -bar DiffOrig aboveleft vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis | wincmd p | diffthis

" 拡張子からテンプレートファイルを判別し読み込む
command! -bar LoadTemplate 0r $XDG_CONFIG_HOME/nvim/template/.%:e

" clang-formatにかける
command! -bar -range=% ClangFormat <line1>,<line2>!clang-format

" typo対策
cnoreabbrev <expr> W (getcmdtype () ==# ":" && getcmdline () ==# "W") ? "w" : "W"

" root権限に昇格して書き込み
" neovimでは機能しない https://github.com/neovim/neovim/issues/8217 ←won't fix……
cnoreabbrev <expr> w!! (getcmdtype () ==# ":" && getcmdline () ==# "w!!") ? "w !sudo tee > /dev/null %" : "w!!"
