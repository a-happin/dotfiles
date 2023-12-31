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
" ** ?
" ********************************

" カーソル直下が空文字, 空白, ',', ';' or 括弧閉じ
" |)
function! s:should_auto_complete (post)
  return a:post ==# '' || exists ('b:my_pairs_completion_stack[-1]') || a:post =~# '\v^\s|^[,;)}\]>」』）】》〉］]'
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
    " ': 直前がキーワードの場合補完しない
    " ': rustかつprevに'<'が含まれている場合はlifetimeの可能性が高いため補完しない
    if a:start ==# ''''
      return (a:prev !~# '\v\k''$') && (&filetype !=# 'rust' || a:prev !~# '<') && s:should_auto_complete (a:post) ? '''' : ''

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
  if exists ('b:my_pairs_completion_stack[-1]')
    if s:starts_with (a:post, b:my_pairs_completion_stack[-1])
      if a:key ==# b:my_pairs_completion_stack[-1]
        " pop
        call remove (b:my_pairs_completion_stack, -1)
        return ['', repeat ("\<Right>", strchars (a:key))]
      endif
    else
      call my_pairs#clear_stack ()
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
    let end = s:opening_pair (a:prev . a:key, a:post, res[0] ==# '', a:key, a:end)
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
    let end = s:opening_pair (a:prev . a:key, a:post, res[0] ==# '', a:key, a:end)
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
  if exists ('b:my_pairs_completion_stack[-1]')
    if b:my_pairs_completion_stack[-1] ==# a:end
      " pop
      call remove(b:my_pairs_completion_stack, -1)
    else
      call my_pairs#clear_stack ()
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

" カーソルの右に対して作用するなにか
" <Right> <Delete> <C-Delete>
function! my_pairs#keymapping_right_or_delete (get_post, actual_key, key_1step) abort
  if exists ('b:my_pairs_completion_stack[-1]')
    " if s:starts_with (call (a:get_post, []), b:my_pairs_completion_stack[-1])
    if s:starts_with (a:get_post (), b:my_pairs_completion_stack[-1])
      " pop
      let end = remove (b:my_pairs_completion_stack, -1)
      return repeat (a:key_1step, strchars (end))
    endif

  endif

  return a:actual_key
endfunction


" ********************************
" ** stack
" ********************************
function! s:push_stack (end) abort
  if !exists ('b:my_pairs_completion_stack')
    let b:my_pairs_completion_stack = []
    augroup my_pairs_completion_stack-reset
      autocmd! * <buffer>
      autocmd InsertLeave,CmdLineLeave <buffer> ++once call my_pairs#clear_stack ()
      " autocmd CursorMovedI <buffer> call s:check_stack ()
    augroup END
  endif

  call add (b:my_pairs_completion_stack, a:end)
endfunction

function! my_pairs#clear_stack () abort
  if exists ('b:my_pairs_completion_stack')
    unlet b:my_pairs_completion_stack
    autocmd! my_pairs_completion_stack-reset * <buffer>
  endif
endfunction

" 位置も保存しないと正確じゃないから微妙
" function! s:check_stack () abort
"   if exists ('b:my_pairs_completion_stack[-1]') && !s:starts_with (strpart (getline ('.'), col ('.') - 1), b:pair_completion_stack[-1])
"     unlet b:my_pairs_completion_stack
"     autocmd! my_pairs_completion_stack-reset * <buffer>
"   endif
" endfunction
