" カーソル位置の文字
function! s:cursor_char () abort
  return matchstr (getline ('.') , '.' , col ('.') - 1)
endfunction

function! s:getline_c () abort
  let str = getcmdline ()
  let pos = getcmdpos () - 1
  let prev = strpart (str, 0, pos)
  let post = strpart (str, pos)
endfunction


" ********************************
" ** 標準で用意しろ
" ********************************
function! s:starts_with (str, x) abort
  " return a:str =~# join (['\v^\V', a:x], '')
  return strpart (a:str, 0, strlen (a:x)) ==# a:x
endfunction

function! s:ends_with (str, x) abort
  " return a:str =~# join (['\V', a:x, '\v$'], '')
  return strpart (a:str, strlen (a:str) - strlen (a:x)) ==# a:x
endfunction


" ********************************
" ** data
" ********************************
let s:parens = [
  \ ['(', ')'],
  \ ['{', '}'],
  \ ['[', ']'],
  \ ['<', '>'],
  \ ['「', '」'],
  \ ['『', '』'],
  \ ['【', '】'],
  \ ['〈', '〉'],
  \ ['《', '》'],
  \ ['（', '）'],
  \ ['［', '］'],
\]

let s:quotations = [
  \ '''',
  \ '"',
  \ '```',
  \ '`',
\]


" ********************************
" ** stack
" ********************************
function! s:push_stack (end) abort
  if !exists ('b:my_pairs_stack')
    let b:my_pairs_stack = []
    augroup my_pairs_stack_reset
      autocmd! * <buffer>
      autocmd InsertLeave,CmdLineLeave <buffer> ++once call my_pairs#clear_stack ()
      " autocmd CursorMovedI <buffer> call s:check_stack ()
    augroup END
  endif

  call add (b:my_pairs_stack, a:end)
endfunction

" WARNING: do not call if stack is empty
function! my_pairs#pop_stack () abort
  return remove (b:my_pairs_stack, -1)
endfunction

" スタックが空ではない && postの開始文字列がスタックのtopと一致している
function! my_pairs#match_stack (post) abort
  return exists ('b:my_pairs_stack[-1]') && s:starts_with (a:post, b:my_pairs_stack[-1])
endfunction

function! s:unsafe_clear_stack () abort
  unlet b:my_pairs_stack
  autocmd! my_pairs_stack_reset * <buffer>
endfunction

function! my_pairs#clear_stack () abort
  if exists ('b:my_pairs_stack')
    call s:unsafe_clear_stack ()
  endif
endfunction


" ********************************
" ** ?
" ********************************

" カーソル直下が空文字, 空白, ',', ';' or 括弧閉じ
" |)
function! s:should_auto_complete (post)
  return a:post ==# '' || my_pairs#match_stack (a:post) || a:post =~# '\v^\s|^[,;)}\]>」』）】》〉］]'
endfunction

" 括弧閉じるの補完関数
" prev: string   カーソルまでの文字列(exclusive)。常にprev.ends_with (start)である。
" post: string   カーソル以降の文字列(inclusive)。
" is_moved: bool この関数が移動によって呼ばれたかどうか(閉じた直後かどうかでもある)
" start: string  開き括弧
" end:   string  閉じ括弧
" return: string 補完する閉じ括弧。補完しない場合は空文字列
function! s:opening_pair (prev, post, is_moved, start, end) abort
  " paren
  if a:start !=# a:end
    return s:should_auto_complete (a:post) ? a:end : ''

  " space
  elseif a:start ==# ' '
    for [start, end] in s:parens
      if s:ends_with (a:prev, start . a:start) && s:starts_with (a:post, end)
        return ' '
      endif
    endfor

  " quot
  elseif !a:is_moved
    " 直前が\の場合補完しない
    if s:ends_with (a:prev, '\' . a:start)
      return ''
    endif
    " ': 直前がキーワードの場合補完しない
    " ': rustかつprevが'&'で終わっている or '<'が含まれている場合はlifetimeの可能性が高いため補完しない
    if a:start ==# ''''
      return (a:prev !~# '\v\k''$') && (&filetype !=# 'rust' || a:prev !~# '\v\&''$|\<') && s:should_auto_complete (a:post) ? '''' : ''

    " ": vimscriptかつ行頭の場合はコメントなので補完しない
    elseif a:start ==# '"'
      return (&filetype !=# 'vim' || a:prev !~# '\v^\s*"$') && s:should_auto_complete (a:post) ? '"' : ''

    " `
    elseif a:start ==# '`'
      return s:should_auto_complete (a:post) ? s:ends_with (a:prev, '```') ? '```' : '`' : ''

    else
      return s:should_auto_complete (a:post) ? a:end : ''
    endif
  endif

  return ''
endfunction

" 補完スタックがあり入力が一致したとき、単に右に移動。
" post:   string   カーソル直後の文字列(inclusive)
" key:    string   入力したキー
" return: string[] 入力するべきキーのリスト。長さが1以上であり、先頭要素はa:keyと同じか空文字列である(空文字列になっている場合は入力がキャンセルされた)
function! s:closing_pair (post, key) abort
  if exists ('b:my_pairs_stack[-1]')
    if s:starts_with (a:post, b:my_pairs_stack[-1])
      if a:key ==# b:my_pairs_stack[-1]
        " pop
        call remove (b:my_pairs_stack, -1)
        return ['', repeat ("\<Right>", strchars (a:key))]
      endif
    else
      call s:unsafe_clear_stack ()
    endif
  endif

  return [a:key]
endfunction


" ********************************
" ** keymapping
" ********************************

" 括弧とか
function! my_pairs#keymapping_pair (prev, post, key, end) abort
  let res = s:closing_pair (a:post, a:key)

  if a:end !=# ''
    let end = s:opening_pair (a:prev . a:key, res[0] ==# '' ? strpart (a:post, strlen (a:key)) : a:post, res[0] ==# '', a:key, a:end)
    if end !=# ''
      call s:push_stack (end)
      call add (res, end)
      call add (res, repeat ("\<Left>", strchars (end)))
    endif
  endif

  return join (res, '')
endfunction

" <Space>を想定
function! my_pairs#keymapping_open_only (prev, post, key, end) abort
  let res = [a:key]

  if a:end !=# ''
    let end = s:opening_pair (a:prev . a:key, res[0] ==# '' ? strpart (a:post, strlen (a:key)) : a:post, res[0] ==# '', a:key, a:end)
    if end !=# ''
      call s:push_stack (end)
      call add (res, end)
      call add (res, repeat ("\<Left>", strchars (end)))
    endif
  endif

  return join (res, '')
endfunction

" <CR>
function! my_pairs#keymapping_cr (prev, post) abort
  for [start, end] in s:parens
    if s:starts_with (a:post, end) && s:ends_with (a:prev, start)
      return "\<CR>\<Up>\<End>\<CR>"
    endif
  endfor

  return "\<CR>"
endfunction

function! s:delete_pairs (start, end) abort
  if exists ('b:my_pairs_stack[-1]')
    if b:my_pairs_stack[-1] ==# a:end
      " pop
      call remove(b:my_pairs_stack, -1)
    else
      call s:unsafe_clear_stack ()
    endif
  endif
  return join ([repeat ("\<BS>", strchars (a:start)), repeat ("\<Del>", strchars (a:end))], '')
endfunction

" <BS>
function! my_pairs#keymapping_backspace (prev, post, key) abort
  " 括弧を探す
  for [start, end] in s:parens
    if s:starts_with (a:post, end) && s:ends_with (a:prev, start)
      return s:delete_pairs (start, end)
    endif
  endfor

  " quotを探す
  for quot in s:quotations
    if s:starts_with (a:post, quot) && s:ends_with (a:prev, quot)
      return s:delete_pairs (quot, quot)
    endif
  endfor

  " 括弧に囲まれた空白
  if s:starts_with (a:post, ' ')
    if s:ends_with (a:prev, ' ')
      for [start, end] in s:parens
        if s:starts_with (a:post, ' ' . end) && s:ends_with (a:prev, start . ' ')
          return s:delete_pairs (' ', ' ')
        endif
      endfor
    endif
    return a:key
  endif

  return a:key
endfunction

finish


" 位置も保存しないと正確じゃないから微妙
" function! s:check_stack () abort
"   if exists ('b:my_pairs_stack[-1]') && !s:starts_with (strpart (getline ('.'), col ('.') - 1), b:pair_completion_stack[-1])
"     unlet b:my_pairs_stack
"     autocmd! my_pairs_stack_reset * <buffer>
"   endif
" endfunction


" ********************************
" ** example
" ********************************
inoremap <expr> <Right> my_pairs#match_stack (strpart (getline ('.'), col ('.') - 1)) ? repeat ('<Right>', strchars (my_pairs#pop_stack ())) : '<Cmd>call my_pairs#clear_stack ()<CR><Right>'
inoremap <expr> <Del> my_pairs#match_stack (strpart (getline ('.'), col ('.') - 1)) ? repeat ('<Del>', strchars (my_pairs#pop_stack ())) : '<Cmd>call my_pairs#clear_stack ()<CR><Del>'

