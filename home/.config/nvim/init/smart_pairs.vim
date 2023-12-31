" カーソル位置の文字
function! s:cursor_char () abort
  return matchstr (getline ('.') , '.' , col ('.') - 1)
endfunction

" 現在の行にある文字列をカーソル位置の前と後に分割して返す
" 前はカーソル直下の文字を含まない
" 後はカーソル直下の文字を含む
function! s:getline () abort
  let str = getline ('.')
  let pos = col ('.') - 1
  let prev = strpart (str, 0, pos)
  let post = strpart (str, pos)
  return [prev, post]
endfunction

function! s:starts_with (str, x) abort
  return a:str =~# join (['\v^\V', a:x], '')
endfunction

function! s:ends_with (str, x) abort
  return a:str =~# join (['\V', a:x, '\v$'], '')
endfunction



let s:quotations = [
  \   '''',
  \   '"',
  \   '`',
  \   '```',
  \ ]

let s:parens = [
  \ ['(', ')'],
  \ ['{', '}'],
  \ ['[', ']'],
  \ ['<', '>'],
  \ ['「', '」'],
  \ ['『', '』'],
  \ ['（', '）'],
  \ ['【', '】'],
  \ ['《', '》'],
  \ ['〈', '〉'],
  \ ['［', '］'],
\]

" ( | )
function! s:is_in_empty_parenthes (prev, post) abort
  for [start, end] in s:parens
    if s:ends_with (a:prev, start) && s:starts_with (a:post, end)
      return v:true
    endif
  endfor

  return v:false
endfunction

" '|'
function! s:is_in_empty_quotation (prev, post) abort
  for quot in s:quotations
    if s:ends_with (a:prev, quot) && s:starts_with (a:post, quot)
      return 1
    endif
  endfor

  return 0
endfunction

" ( | )
function! s:is_in_empty_parenthes_with_space (prev, post) abort
  for [begin, end] in s:parens
    if s:ends_with (a:prev, begin . ' ') && s:starts_with (a:post, ' ' . end)
      return 1
    endif
  endfor

  return 0
endfunction

" カーソル直下が空文字, 空白, ',', ';' or 括弧閉じ
" |)
function! s:should_auto_complete (post)
  return a:post ==# '' || a:post =~# '\v^\s|^[,;)}\]>」』）】》〉］]'
endfunction


function! s:smart_pairs_completion_func (prev, post, is_moved) abort
  " paren
  for [start, end] in s:parens
    if s:ends_with (a:prev, start)
      return s:should_auto_complete (a:post) ? end : ''
    endif
  endfor

  " space: 括弧に囲まれていればスペースを2つ挿入する
  if s:ends_with (a:prev, ' ')
    for [start, end] in s:parens
      if s:ends_with (a:prev, start . ' ') && s:starts_with (a:post, end)
        return ' '
      endif
    endfor
    return ''

  " quot
  elseif !a:is_moved
    if s:ends_with (a:prev, '```')
      return s:should_auto_complete (a:post) ? '```' : ''

    " ': 直前がキーワードの場合補完しない
    " ': rustかつprevに'<'が含まれている場合はlifetimeの可能性が高いため補完しない
    elseif s:ends_with (a:prev, '''')
      return (a:prev !~# '\v\k''$') && (&filetype !=# 'rust' || a:prev !~# '<') && s:should_auto_complete (a:post) ? '''' : ''

    " ": vimscriptかつ行頭の場合はコメントなので補完しない
    elseif s:ends_with (a:prev, '"')
      return (&filetype !=# 'vim' || a:prev !~# '\v^\s*"$') && s:should_auto_complete (a:post) ? '"' : ''

    elseif s:ends_with (a:prev, '`')
      return s:should_auto_complete (a:post) ? '`' : ''
    endif
  endif

  return ''
endfunction


function! s:push_stack (end) abort
  if !exists ('b:completion2')
    let b:pair_completion_stack = #{i: 0, stack: []}
    augroup reset-parentheses-completion-stack
      autocmd! * <buffer>
      autocmd InsertLeave <buffer> ++once unlet! b:completion2
    augroup END
  endif

  call add (b:pair_completion_stack, a:end)
endfunction


" 補完スタックがあり入力が一致したとき、単に右に移動。
" 補完スタックと違う内容を入力したとき、閉じ括弧を復元する。
" 入力によって補完をチェックして返す。
" prev: カーソル直前の文字列(exclusive)
" post: カーソル直後の文字列(inclusive)
" key:  入力したキー。すでに入力し終わっていたら空文字列
" return: string[] 入力するべきキーのリスト。長さが1以上であり、先頭要素はa:keyと同じか空文字列である(空文字列になっている場合は入力がキャンセルされた)
function! s:smart_pairs_util_keymap (prev, post, key) abort
  let post = a:post
  let last = a:key ==# '' ? matchstr (a:prev, '.$') : a:key
  let res = [a:key]

  if exists ('b:completion2.stack[-1]')
    if s:starts_with (a:post, strpart (b:pair_completion_stack[-1], b:pair_completion_stack.i))
      if s:starts_with (a:post, last)

        " move cursor
        let b:pair_completion_stack.i += strlen (last)
        if strlen (b:pair_completion_stack[-1]) == b:pair_completion_stack.i
          " pop
          let b:pair_completion_stack.i = 0
          call remove (b:pair_completion_stack, -1)
        endif
        call add (res, a:key ==# '' ? "\<Del>" : "\<Right>")
        let res[0] = ''
        let post = strpart (a:post, strlen (last))
      else
        " restore skipped
        let skipped = strpart (b:pair_completion_stack[-1], 0, b:pair_completion_stack.i)
        let b:pair_completion_stack.i = 0
        call add (res, skipped)
        call add (res, repeat ("\<Left>", strchars (skipped)))
        let post = skipped . a:post
      endif
    else
      unlet b:pair_completion_stack
    endif
  endif

  let end = s:smart_pairs_completion_func (a:prev . a:key, post, res[0] ==# '')
  if end !=# ''
    call s:push_stack (end)
    call add (res, end)
    call add (res, repeat ("\<Left>", strchars (end)))
  endif

  return res
endfunction
" *******************************
" **  function!
" *******************************


""""""""""""""""""""""""""""""""
" Key
""""""""""""""""""""""""""""""""


" 括弧開始
" カーソル直下が空白or括弧閉じの場合、閉じ括弧を補完
" prev_and_c: key入力後のカーソル直前までの文字列(exclusive)
" post:     カーソル以降の文字列(inclusive)
" is_moved: 入力したキーが移動キーだったかどうか
" function! s:opened_pair (prev, post, is_moved) abort
"   let end = s:find_matched_end (a:prev, a:is_moved)

"   if end !=# '' && s:should_auto_complete (a:post)
"     call s:push_stack (end)
"     return end . repeat ("\<Left>", strchars (end))
"   else
"     return ''
"   endif
" endfunction


function! s:smart_pairs_backspace (key) abort
  if exists ('b:completion2.stack[-1]')
    let [prev, post] = s:getline ()
    let top_end = strpart (b:pair_completion_stack[-1], b:pair_completion_stack.i)
    if s:starts_with (post, top_end)
      if b:pair_completion_stack.i == 0

        " スタックのtopが空白で、直前にも空白がある
        if top_end ==# ' ' && s:ends_with (prev, ' ')
          " pop
          call remove (b:pair_completion_stack, -1)
          return "\<BS>\<Del>"
        endif

        " 括弧を探す
        for [start, end] in s:parens
          if end ==# b:pair_completion_stack[-1] && s:ends_with (prev, start)
            " pop
            let b:pair_completion_stack.i = 0
            call remove (b:pair_completion_stack, -1)
            return join ([repeat ("\<BS>", strchars (start)), repeat ("\<Del>", strchars (end))], '')
          endif
        endfor

        " quotを探す
        for q in s:quotations
          if q ==# b:pair_completion_stack[-1] && s:ends_with (prev, q)
            " pop
            let b:pair_completion_stack.i = 0
            call remove (b:pair_completion_stack, -1)
            return join ([repeat ("\<BS>", strchars (q)), repeat ("\<Del>", strchars (q))], '')
          endif
        endfor

      else
        " restore skipped
        let skipped = strpart (b:pair_completion_stack[-1], 0, b:pair_completion_stack.i)
        let b:pair_completion_stack.i = 0
        return join ([a:key , skipped , repeat ("\<Left>", strchars (skipped))], '')
      endif
    elseif b:pair_completion_stack.i != 0
      unlet b:pair_completion_stack
    endif
  endif

  return a:key
endfunction

function! s:smart_pairs_delete (key) abort
  if exists ('b:completion2.stack[-1]')
    let [prev, post] = s:getline ()
    let end = strpart (b:pair_completion_stack[-1], b:pair_completion_stack.i)
    if s:starts_with (post, end)
      " pop
      let b:pair_completion_stack.i = 0
      call remove (b:pair_completion_stack, -1)
      return repeat ("\<Del>", strchars (end))
    endif
  endif

  return a:key
endfunction

" function! s:end_parenthesis (key) abort
"   let [prev, post] = s:getline ()
"   return s:closing_pair (prev, post, a:key)
" endfunction

augroup smart_pairs_jk
  autocmd!
  autocmd InsertCharPre * call s:insert_char_pre ()
augroup END

function! s:insert_char_pre () abort
  " if get (g:, -1)
  if get (g:, 'smart_pairs_blocking', v:false)
    return
  endif
  let [prev, post] = s:getline ()
  let [v:char; res] = s:smart_pairs_util_keymap (prev, post, v:char)
  " let [c,res1,post] = s:closing_pair (prev, post, v:char)
  " let res2 = s:opened_pair (prev . v:char, post, c ==# '')
  call add (res, "\<Cmd>let g:smart_pairs_blocking = v:false\<CR>")
  let g:smart_pairs_blocking = v:true
  " let v:char = c
  call feedkeys (join (res, ''), 'n')
endfunction
