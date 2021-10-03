scriptencoding utf-8

" *******************************
" **  function(script local)
" *******************************
function! s:cnoreabbrev (word, str) abort
  execute 'cnoreabbrev <expr>' . a:word . ' (getcmdtype () ==# ":" && getcmdline () ==# "' . a:word . '") ? "' . a:str . '" : "' . a:word . '"'
endfunction

function! s:ripgrep_fzf (query, fullscreen) abort
  let command_fmt = 'rg --hidden --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf (command_fmt, shellescape (a:query))
  let reload_command = printf (command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:' . reload_command]}
  call fzf#vim#grep (initial_command, 1, fzf#vim#with_preview (spec), a:fullscreen)
endfunction


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

" ripgrepによるファイル横断検索
command! -nargs=* -bang Rg call s:ripgrep_fzf (<q-args>, <bang>0)
call s:cnoreabbrev ('rg', 'Rg')

" typo対策
call s:cnoreabbrev ('W', 'w')

" root権限に昇格して書き込み
" neovimでは機能しない https://github.com/neovim/neovim/issues/8217 ←won't fix……
call s:cnoreabbrev ('w!!', 'w !sudo tee > /dev/null %')
