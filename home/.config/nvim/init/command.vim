" *******************************
" **  function(script local)
" *******************************
function! s:cnoreabbrev (word, str) abort
  execute 'cnoreabbrev <expr>' a:word '(getcmdtype () ==# ":" && strpart (getcmdline (), 0, getcmdpos () - 1) ==# "' . a:word . '") ? "' . a:str . '" : "' . a:word . '"'
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
  if filereadable (template)
    execute '0r' template
  else
    let template_vim = template . '.vim'
    if filereadable (template_vim)
      execute 'source' template_vim
    else
      echoerr 'template file not found'
    endif
  endif
endfunction


function! s:keep_cursor (cmd) abort
  let cursor = winsaveview ()
  execute 'keeppatterns keepjumps ' . a:cmd
  call winrestview (cursor)
endfunction


" *******************************
" **  command
" *******************************

" minpac
" command! -bar PackInit call pack#init ()
" command! -bar PackUpdate call pack#init () | call minpac#update ()
" command! -bar PackClean call pack#init () | call minpac#clean ()

command! -bar Reload source ${MYVIMRC}
command! -bar Note tabnew +lcd\ %:h ~/Dropbox/note/note.md
command! -bar Nvimrc tabnew $MYVIMRC
call s:cnoreabbrev ("nvimrc", "Nvimrc")
command! -bar SourceThis if expand ('%:e') =~# '\v^vim$|^lua$' | source % | call my_notify#notify (':source ' .. expand ('%')) | endif

" terminal
command! -nargs=* -complete=shellcmd Hterminal botright 20split | terminal <args>
command! -nargs=* -complete=shellcmd Vterminal botright vertical split | terminal <args>
command! -nargs=* -complete=shellcmd Tterminal tab terminal <args>
command! -bar ToggleTerminal call s:toggle_terminal ()

" カーソル位置のsyntax hightlight group
"command! -bar CurrentSyntax echo synIDattr(synID(line('.'), col('.'), 1), 'name')
" NOTE: Use ":Inspect" command instead.
command! -bar CurrentSyntax Inspect

" session
command! -bar -nargs=1 SaveSession call mkdir ($XDG_DATA_HOME . '/nvim/sessions', 'p') | mksession! $XDG_DATA_HOME/nvim/sessions/<args>.vim
command! -bar -nargs=1 LoadSession source $XDG_DATA_HOME/nvim/sessions/<args>.vim

" 最後に保存してからのdiff
command! -bar DiffOrig tab split | aboveleft vert new | setlocal buftype=nofile bufhidden=delete noswapfile | read ++edit # | 0d_ | diffthis | wincmd p | diffthis

" 最後のコミットからのdiff
command! -bar GitDiff tabnew | setlocal buftype=nofile bufhidden=delete noswapfile | setfiletype gitcommit | execute 'read ++edit !git diff #' | normal! gg
command! -bar GitDiff2 tab split | aboveleft vert new | setlocal buftype=nofile bufhidden=delete noswapfile | execute '%!git show :./' . shellescape (expand ('#')) | diffthis | wincmd p | diffthis

" 拡張子からテンプレートファイルを判別し読み込む
command! -bar LoadTemplate call s:load_template ()

" clang-formatにかける
command! -bar -range=% ClangFormat <line1>,<line2>!clang-format

" rustfmtにかける
command! -bar -range=% RustFormat call s:keep_cursor ("<line1>,<line2>!rustfmt")

" Rename
command! -bar -nargs=1 -complete=file Rename try | saveas <args> | call delete (expand ('#')) | catch | file # | echoerr 'Rename failed.' | endtry

"command! -bar -range=% ToSnakeCase <line1>,<line2>s/\v([a-z_]\@=)([A-Z])/\1_\l\2/g

" reset lsp
" command! -bar LspReset lua vim.diagnostic.reset ()

" v_g<C-a>
command! -bar -range -nargs=? Sequentialize if <line1> ==# <line2> | call my_notify#error ("範囲選択してください", #{title: "Sequentialize"}) | elseif <q-args> !~# '\v^\d*$' | call my_notify#error("invalid argument " .. <q-args>, #{title: "Sequentialize"}) | else | execute "normal! gv<args>g<C-a>" | endif

function! s:clear_registers() abort
  for r in split('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz/', '\zs')
    call setreg(r, [])
  endfor
endfunction
command! -bar ClearRegisters call s:clear_registers()

" ripgrepによるファイル横断検索
call s:cnoreabbrev ('rg', 'Rg')

" typo対策
call s:cnoreabbrev ('W', 'w')
" call s:cnoreabbrev ('newtab', 'tabnew')
call s:cnoreabbrev ('qc', 'cq')

" abbreviation
call s:cnoreabbrev ('note', 'Note')

" root権限に昇格して書き込み
" neovimでは機能しない https://github.com/neovim/neovim/issues/1716 ←won't fix……?
" call s:cnoreabbrev ('w!!', 'w !sudo tee > /dev/null %')
call s:cnoreabbrev ('w!!', 'SudaWrite')

" そのバッファのcwdをファイルのあるディレクトリに変更する
call s:cnoreabbrev ('lcdh', 'lcd %:h')
" そのバッファのcwdをファイルのあるディレクトリの上に変更する
call s:cnoreabbrev ('lcdhh', 'lcd %:p:h:h')

" そのバッファのcwdをgit rootに変更する
function! s:lcd_git_root() abort
  let d = system("git -C " .. expand("%:h:S") .. " rev-parse --show-toplevel 2>/dev/null")
  if d !=# ''
    execute 'lcd ' .. d
  endif
endfunction
command! -bar LcdGitRoot call s:lcd_git_root()
call s:cnoreabbrev ('lcdg', 'LcdGitRoot')

" ヘルプを縦に分割して開く
call s:cnoreabbrev ('h', 'vertical help')
call s:cnoreabbrev ('help', 'vertical help')

" create new tab
call s:cnoreabbrev ('newtab', 'tab split')
