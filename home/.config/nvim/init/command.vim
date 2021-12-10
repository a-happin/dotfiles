scriptencoding utf-8

" *******************************
" **  function(script local)
" *******************************
function! s:cnoreabbrev (word, str) abort
  execute 'cnoreabbrev <expr>' a:word '(getcmdtype () ==# ":" && getcmdline () ==# "' . a:word . '") ? "' . a:str . '" : "' . a:word . '"'
endfunction

" 現在のバッファがターミナル: hide
" タブ内にターミナルがある  : そこに移動
" 裏にターミナルがある      : 下にウインドウを生成->呼び出し O(バッファ数^2)なのなんとかならんか？
" それ以外                  : 新しくターミナルを生成
function! s:toggle_terminal () abort
  if &buftype ==# 'terminal'
    hide
  else
    let bufs = tabpagebuflist ()
    for i in range (1, len (bufs))
      if getbufvar (bufs[i - 1], '&buftype') ==# 'terminal'
        execute i . 'wincmd w'
        return
      endif
    endfor
    let bufs = filter (range (1, bufnr ('$')), {_, v -> buflisted (v) && empty (win_findbuf (v))})
    for b in bufs
      if getbufvar (b, '&buftype') ==# 'terminal'
        botright 20new
        execute 'b' b
        return
      endif
    endfor
    botright 20new
    terminal
  endif
endfunction

"
function! s:load_template () abort
  let ext = expand ('%:e')
  let template = $XDG_CONFIG_HOME . '/nvim/template/' . (ext ==# '' ? expand ('%:t') : '.' . ext)
  execute '0r' template
endfunction

" *******************************
" **  command
" *******************************

" minpac
command! -bar PackInit call pack#init ()
command! -bar PackUpdate call pack#init () | call minpac#update ()
command! -bar PackClean call pack#init () | call minpac#clean ()

command! -bar Reload source ${MYVIMRC}
command! -bar Note edit ~/Dropbox/note/note.md | lcd %:h

" terminal
command! -nargs=* -complete=shellcmd Hterminal botright 20new | terminal <args>
command! -nargs=* -complete=shellcmd Vterminal botright vertical new | terminal <args>
command! -nargs=* -complete=shellcmd Tterminal tabnew | terminal <args>
command! -bar ToggleTerminal call s:toggle_terminal ()

" カーソル位置のsyntax hightlight group
command! -bar CurrentSyntax echo synIDattr(synID(line('.'), col('.'), 1), 'name')

" session
command! -bar -nargs=1 SaveSession call mkdir ($XDG_DATA_HOME . '/nvim/sessions', 'p') | mksession! $XDG_DATA_HOME/nvim/sessions/<args>.vim
command! -bar -nargs=1 LoadSession source $XDG_DATA_HOME/nvim/sessions/<args>.vim

" 最後に保存してからのdiff
command! -bar DiffOrig aboveleft vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis | wincmd p | diffthis

" 拡張子からテンプレートファイルを判別し読み込む
command! -bar LoadTemplate call s:load_template ()

" clang-formatにかける
command! -bar -range=% ClangFormat <line1>,<line2>!clang-format

"command! -bar -range=% ToSnakeCase <line1>,<line2>s/\v([a-z_]\@=)([A-Z])/\1_\l\2/g

command! -bar GetWindowsClipboard let @" = system ('powershell.exe get-clipboard | sed -z ''s/\r\n$//''')

" ripgrepによるファイル横断検索
call s:cnoreabbrev ('rg', 'Rg')

" typo対策
call s:cnoreabbrev ('W', 'w')

" abbreviation
call s:cnoreabbrev ('note', 'Note')

" root権限に昇格して書き込み
" neovimでは機能しない https://github.com/neovim/neovim/issues/8217 ←won't fix……
call s:cnoreabbrev ('w!!', 'w !sudo tee > /dev/null %')
