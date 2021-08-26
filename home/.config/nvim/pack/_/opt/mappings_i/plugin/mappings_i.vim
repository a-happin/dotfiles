scriptencoding utf-8

" --------------------------------
"  initialize
" --------------------------------
let b:parentheses_completion_stack = 0

augroup reset-parentheses-completion-stack
  autocmd!
  autocmd InsertEnter * let b:parentheses_completion_stack = 0
augroup END


" --------------------------------
" - disable
" --------------------------------
" Ctrl-Cによる挿入モードからの離脱を禁止
" （InsertLeaveが呼ばれないので内部状態がおかしくなる）
inoremap <C-c> <Nop>


" --------------------------------
"  自動補完
" --------------------------------

" ポップアップ補完メニューが表示されているときは次の候補を選択
inoremap <silent><expr> <Tab> <SID>tab_key ()

" ポップアップ補完メニューが表示されているときは前の候補を選択
" それ以外はインデントを1つ下げる
inoremap <silent><expr> <S-Tab> pumvisible () ? '<C-p>' : '<C-d>'

" ポップアップ補完メニューが表示されているときは確定
inoremap <silent><expr> <CR> <SID>cr_key ()

" 括弧の対応の補完
inoremap <silent><expr> ( <SID>begin_parenthesis ('(',')')
inoremap <silent><expr> ) <SID>end_parenthesis   ('(',')')
inoremap <silent><expr> { <SID>begin_parenthesis ('{','}')
inoremap <silent><expr> } <SID>end_parenthesis   ('{','}')
inoremap <silent><expr> [ <SID>begin_parenthesis ('[',']')
inoremap <silent><expr> ] <SID>end_parenthesis   ('[',']')

" クォーテーションの自動補完
inoremap <silent><expr> " <SID>quotation_key ('"')
inoremap <silent><expr> ' <SID>quotation_key ('''')
inoremap <silent><expr> ` <SID>quotation_key ('`')

" Backspace
inoremap <silent><expr> <BS> <SID>backspace_key ()
"inoremap <expr><Del> delete_key ()

" いいかんじの'/'
inoremap <silent><expr> / <SID>slash_key ()

" スペースキー
inoremap <silent><expr> <Space> <SID>space_key ()

" *******************************
" **  function!
" *******************************

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
  return a:str =~# '\v^\V' . a:x
endfunction

function! s:ends_with (str, x) abort
  return a:str =~# '\V' . a:x . '\v$'
endfunction

let s:pairs = {
  \ '(': ')',
  \ '{': '}',
  \ '[': ']',
  \ '<': '>',
  \ '''': '''',
  \ '"': '"',
  \ '`': '`',
  \ }

" 空の括弧の中にいるかどうか
function! s:is_in_empty_parentheses (prev, post) abort
  for [begin, end] in items (s:pairs)
    " skip quotation
    if begin ==# end
      continue
    endif

    if s:ends_with (a:prev, begin) && s:starts_with (a:post, end)
      return 1
    endif
  endfor

  return 0
endfunction

function! s:is_in_empty_quotation (prev, post) abort
  for [begin, end] in items (s:pairs)
    " skip parentheses
    if begin !=# end
      continue
    endif

    if s:ends_with (a:prev, begin) && s:starts_with (a:post, end)
      return 1
    endif
  endfor

  return 0
endfunction

function! s:is_in_empty_parenthes_with_space (prev, post) abort
  for [begin, end] in items (s:pairs)
    " skip quotation
    if begin ==# end
      continue
    endif

    if s:ends_with (a:prev, begin . ' ') && s:starts_with (a:post, ' ' . end)
      return 1
    endif
  endfor

  return 0
endfunction

" 括弧閉じるを補完するべきかどうか
" カーソル位置が末尾、
" カーソル位置に空白、
" カーソル位置に括弧閉じるがある場合は補完するべき。(連続で入力したときに補完されないのはおかしいので)
function! s:should_complete_end_parenthesis (prev, post) abort
  if a:post =~# '\v^$|^\s'
    return 1
  endif

  for [begin, end] in items (s:pairs)
    " skip quotation
    if begin ==# end
      continue
    endif

    if s:starts_with (a:post, end)
      return 1
    endif
  endfor

  return 0
endfunction

" quotation閉じるを補完すべきかどうか
" カーソルの前後が空白か括弧のときは補完するべき（と思う）
function! s:should_complete_quotation (prev, post) abort
  let left_flag = 0
  let right_flag = 0

  if a:prev =~# '\v^$|\s$'
    let left_flag = 1
  endif

  if a:post =~# '\v^$|^\s'
    let right_flag = 1
  endif

  for [begin, end] in items (s:pairs)
    if begin ==# end
      continue
    endif

    if s:ends_with (a:prev, begin)
      let left_flag = 1
    endif

    if s:starts_with (a:post, end)
      let right_flag = 1
    endif
  endfor

  return left_flag == 1 && right_flag == 1
endfunction


""""""""""""""""""""""""""""""""
" Key
""""""""""""""""""""""""""""""""

" 括弧開始
" カーソル直下がキーワードでなかった場合、閉じ括弧を補完
function! s:begin_parenthesis (begin, end) abort
  let [prev, post] = s:getline ()
  if s:should_complete_end_parenthesis (prev, post)
    let b:parentheses_completion_stack += 1
    return a:begin . a:end . "\<Left>"
  else
    return a:begin
  endif
endfunction

" 括弧閉じ
" 補完スタックがある時、単に右に移動
" それ以外は括弧閉じる
function! s:end_parenthesis (begin, end) abort
  let [prev, post] = s:getline ()
  if b:parentheses_completion_stack > 0 && post =~# '^' . a:end
    let b:parentheses_completion_stack -= 1
    return "\<Right>"
  else
    return a:end
  endif
endfunction


" quotation
" vimscriptの場合は行頭はコメントなので補完しない
" カーソル位置に同じ文字がある場合は<Right>
" 直前と直後に空白や括弧しかない場合は補完する
" それ以外は補完しない
function! s:quotation_key (key) abort
  let [prev, post] = s:getline ()
  if &filetype ==# 'vim' && prev =~# '\v^\s*$' && a:key ==# '"'
    return a:key
  elseif post =~# '^' . a:key
    return "\<Right>"
  elseif s:should_complete_quotation (prev, post)
    return a:key . a:key . "\<Left>"
  else
    return a:key
  endif
endfunction


" Tab
" キーワードなら補完開始
" スラッシュならファイル名補完開始
" 空行ならインデント調整
" それ以外はTab
function! s:tab_key () abort
  if pumvisible ()
    return "\<C-n>"
  else
    let [prev, post] = s:getline ()
    if prev =~# '\v\k$'
      return "\<C-n>"
    elseif prev =~# '\v/$'
      return "\<C-x>\<C-f>"
    elseif prev ==# '' && post ==# ''
      return "\<C-o>cc\<C-d>\<C-t>"
    else
      return "\<Tab>"
    endif
  endif
endfunction



" CR
" カーソルが{}の間ならいい感じに改行
" カーソルが``の間なら```にして改行
" それ以外は改行
function! s:cr_key () abort
  if pumvisible ()
    return "\<C-y>"
  else
    let [prev, post] = s:getline ()
    if s:is_in_empty_parentheses (prev, post)
      return "\<CR>\<Up>\<End>\<CR>"
    elseif prev =~# '''$' && post =~# '^'''
      return "''\<CR>''\<Up>\<End>\<CR>"
    elseif prev =~# '"$' && post =~# '^"'
      return "\"\"\<CR>\"\"\<Up>\<End>\<CR>"
    elseif prev =~# '`$' && post =~# '^`'
      return "``\<CR>``\<Up>\<End>\<CR>"
    else
      return "\<CR>"
    endif
  endif
endfunction


" Backspace Key
function! s:backspace_key () abort
  let [prev, post] = s:getline ()
  if s:is_in_empty_parentheses (prev, post) || s:is_in_empty_quotation (prev, post) || s:is_in_empty_parenthes_with_space (prev, post)
    return "\<BS>\<Del>"
  else
    return "\<BS>"
  endif
endfunction

" Delete Key
function! s:delete_key () abort
  let [prev, post] = s:getline ()
  if s:is_in_empty_parentheses (prev, post) || s:is_in_empty_quotation (prev, post) || s:is_in_empty_parenthes_with_space (prev, post)
    return "\<BS>\<Del>"
  else
    return "\<Del>"
  endif
endfunction


" Slash Key
" 直前が*または\だった場合、そのまま/
" < だった場合、/を入力した後オムニ補完開始
" それ以外: /を入力した後ファイル名補完開始
function! s:slash_key () abort
  let [prev, post] = s:getline ()
  if prev =~# '\v[/*\\]$'
    return "/"
  elseif prev =~# '\v<$'
    if &omnifunc != ''
      return "/\<C-x>\<C-o>"
    else
      return "/"
    endif
  else
    return "/\<C-x>\<C-f>"
  endif
endfunction

" Space Key
" カーソルが空括弧の間にあった場合に2個挿入
function! s:space_key () abort
  let [prev, post] = s:getline ()
  if s:is_in_empty_parentheses (prev, post)
    return "\<Space>\<Space>\<Left>"
  else
    return "\<Space>"
  endif
endfunction
