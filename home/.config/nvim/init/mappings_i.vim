" --------------------------------
"  initialize
" --------------------------------


" --------------------------------
"  disable
" --------------------------------
" Ctrl-Cによる挿入モードからの離脱を禁止
" （InsertLeaveが呼ばれないので内部状態がおかしくなる）
inoremap <C-c> <Nop>

" なんか出てくるけど誰も望んでない
inoremap <C-S-Insert> <Nop>


" --------------------------------
"  動作系
" --------------------------------
inoremap <C-o> <C-\><C-o>

inoremap <S-Del> <C-\><C-o>dw
inoremap <C-Del> <C-\><C-o>dw
inoremap <C-S-Del> <C-\><C-o>dW

inoremap <C-h> <C-w>


" Debug
inoremap <F7> <Cmd>lua vim.notify(vim.inspect (vim.v.completed_item))<CR>


" --------------------------------
"  移動系
" --------------------------------

" <Cmd>normal! gj<CR>だと少ない行に行って帰ってきたときに戻ってこなくてなんかだめ……
inoremap <expr> <Down> pumvisible () ? '<C-n>' : '<C-\><C-o>gj'
inoremap <expr> <Up> pumvisible () && v:completed_item != {} ? '<C-p>' : '<C-\><C-o>gk'

" カーソルが急に飛ぶとつらいので修正
" どうせならselect modeになってほしい
" &keymodel contains 'startsel' && &selection !=# 'exclusive' のときの挙動がおかしいので修正
" inoremap <silent> <expr> <S-Left>   &keymodel =~# 'startsel' ? &selection !=# 'exclusive' ? '<S-Left>oho<C-g>'     : '<S-Left><C-g>'  : '<Left>'
" inoremap <silent> <expr> <S-Right>  &keymodel =~# 'startsel' ? &selection !=# 'exclusive' ? '<S-Right><Left><C-g>' : '<S-Right><C-g>' : '<Right>'
" inoremap <silent> <expr> <S-Up>     &keymodel =~# 'startsel' ? &selection !=# 'exclusive' ? '<S-Up>oho<C-g>'       : '<S-Up><C-g>'    : '<Up>'
" inoremap <silent> <expr> <S-Down>   &keymodel =~# 'startsel' ? &selection !=# 'exclusive' ? '<S-Down><Left><C-g>'  : '<S-Down><C-g>'  : '<Down>'
" inoremap <silent> <expr> <S-Home>   &keymodel =~# 'startsel' ? &selection !=# 'exclusive' ? '<S-Home>oho<C-g>'     : '<S-Home><C-g>'  : '<Home>'
" inoremap <silent> <expr> <S-End>    &keymodel =~# 'startsel' ? &selection !=# 'exclusive' ? '<S-End><Left><C-g>'   : '<S-End><C-g>'   : '<End>'
" inoremap <silent> <expr> <C-S-Home> &keymodel =~# 'startsel' ? &selection !=# 'exclusive' ? '<S-Home>oho<C-g>'     : '<S-Home><C-g>'  : '<Home>'
" inoremap <silent> <expr> <C-S-End>  &keymodel =~# 'startsel' ? &selection !=# 'exclusive' ? '<S-End><Left><C-g>'   : '<S-End><C-g>'   : '<End>'

" keymodel contains 'startsel' 専用
" select mode にする
if &keymodel =~# 'startsel'
  inoremap <S-Left>  <S-Left><C-g>
  inoremap <S-Right> <S-Right><C-g>
  inoremap <S-Up> <S-Up><C-g>
  inoremap <S-Down> <S-Down><C-g>
  inoremap <S-Home> <S-Home><C-g>
  inoremap <S-End> <S-End><C-g>
endif

" 急に飛ばないで
imap <C-Home> <Home>
imap <C-S-Home> <S-Home>
imap <C-End> <End>
imap <C-S-End> <S-End>
inoremap <PageUp> <C-x><C-y>
inoremap <S-PageUp> <C-x><C-y>
inoremap <PageDown> <C-x><C-e>
inoremap <S-PageDown> <C-x><C-e>


" --------------------------------
"  自動補完
" --------------------------------

" ポップアップ補完メニューが表示されているときは次の候補を選択
inoremap <expr> <Tab> <SID>keymapping_tab ()

" ポップアップ補完メニューが表示されているときは前の候補を選択
" それ以外はインデントを1つ下げる
inoremap <expr> <S-Tab> pumvisible () ? '<C-p>' : pum#visible() ? '<Cmd>call pum#map#select_relative (-1)<CR>' : '<C-d>'


" ポップアップ補完メニューが表示されているときは確定
inoremap <expr> <CR> <SID>keymapping_cr ()

" いいかんじの'/'
inoremap <expr> / <SID>keymapping_slash ()

" 括弧の対応の補完
inoremap <expr> ( <SID>keymapping_pair ('(', ')')
inoremap <expr> ) <SID>keymapping_pair (')', '')
inoremap <expr> { <SID>keymapping_pair ('{', '}')
inoremap <expr> } <SID>keymapping_pair ('}', '')
inoremap <expr> [ <SID>keymapping_pair ('[', ']')
inoremap <expr> ] <SID>keymapping_pair (']', '')
inoremap <expr> 「 <SID>keymapping_pair ('「', '」')
inoremap <expr> 」 <SID>keymapping_pair ('」', '')
inoremap <expr> 『 <SID>keymapping_pair ('『', '』')
inoremap <expr> 』 <SID>keymapping_pair ('』', '')
inoremap <expr> 【 <SID>keymapping_pair ('【', '】')
inoremap <expr> 】 <SID>keymapping_pair ('】', '')
inoremap <expr> 〈 <SID>keymapping_pair ('〈', '〉')
inoremap <expr> 〉 <SID>keymapping_pair ('〉', '')
inoremap <expr> 《 <SID>keymapping_pair ('《', '》')
inoremap <expr> 》 <SID>keymapping_pair ('》', '')
inoremap <expr> （ <SID>keymapping_pair ('（', '）')
inoremap <expr> ） <SID>keymapping_pair ('）', '')
inoremap <expr> ［ <SID>keymapping_pair ('［', '］')
inoremap <expr> ］ <SID>keymapping_pair ('］', '')

" クォーテーションの自動補完
inoremap <expr> " <SID>keymapping_pair ('"', '"')
inoremap <expr> ' <SID>keymapping_pair ('''', '''')
inoremap <expr> ` <SID>keymapping_pair ('`', '`')

" Space
inoremap <expr> <Space> <SID>keymapping_open_only ('<Space>', '<Space>')

" arrow
inoremap <Left> <Cmd>call my_pairs#clear_stack ()<CR><Left>
inoremap <expr> <Right> my_pairs#match_stack (strpart (getline ('.'), col ('.') - 1)) ? repeat ('<Right>', strchars (my_pairs#pop_stack ())) : '<Cmd>call my_pairs#clear_stack ()<CR><Right>'

" Backspace
inoremap <expr> <BS> <SID>keymapping_backspace ('<BS>')
" Delete
inoremap <expr> <Del> my_pairs#match_stack (strpart (getline ('.'), col ('.') - 1)) ? repeat ('<Del>', strchars (my_pairs#pop_stack ())) : '<Cmd>call my_pairs#clear_stack ()<CR><Del>'


" *******************************
" **  function
" *******************************

" Tab
" キーワードなら補完開始
" スラッシュならファイル名補完開始
" 空行ならインデント調整
" それ以外はTab
function! s:keymapping_tab () abort
  if pumvisible ()
    return "\<C-n>"
  elseif pum#visible ()
    return "\<Cmd>call pum#map#select_relative (+1)\<CR>"
  else
    let [prev, post] = s:getline ()
    if prev =~# '\v\k$|:$|->$|\.$'
      if luaeval ('vim.lsp.buf.server_ready ()')
        return "\<Cmd>call ddc#map#manual_complete ()\<CR>"
      else
        return "\<C-n>"
      endif
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
" それ以外は改行
function! s:keymapping_cr () abort
  if pumvisible ()
    if v:completed_item == {}
      return "\<C-y>\<CR>"
    else
      return "\<C-y>"
    endif
  elseif pum#visible ()
    " if v:completed_item == {}
      " return "\<Cmd>call pum#map#confirm()\<CR>\<CR>"
    " else
      return "\<Cmd>call pum#map#confirm()\<CR>"
    " endif
  else
    let [prev, post] = s:getline ()
    return my_pairs#keymapping_cr (prev, post)
  endif
endfunction

" Slash Key
" 直前が*または\だった場合、そのまま/
" < だった場合、/を入力した後オムニ補完開始
" それ以外: /を入力した後ファイル名補完開始
function! s:keymapping_slash () abort
  let [prev, post] = s:getline ()
  if prev =~# '\v[/*\\]$'
    return "/"
  elseif prev =~# '\V<\v$'
    if &omnifunc ==# 'htmlcomplete#CompleteTags'
      return "/\<C-x>\<C-o>\<C-n>\<C-y>\<C-o>=="
    else
      return "/"
    endif
  else
    return "/\<C-x>\<C-f>"
  endif
endfunction


" *******************************
" **  my_pairs
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

function! s:keymapping_pair (key, end) abort
  let [prev, post] = s:getline ()
  return my_pairs#keymapping_pair (prev, post, a:key, a:end)
endfunction

function! s:keymapping_open_only (key, end) abort
  let [prev, post] = s:getline ()
  return my_pairs#keymapping_open_only (prev, post, a:key, a:end)
endfunction

function! s:keymapping_backspace (key) abort
  let [prev, post] = s:getline ()
  return my_pairs#keymapping_backspace (prev, post, a:key)
endfunction


finish
" *******************************
" **  unused
" *******************************

" vimscriptかつ行頭の場合はコメントなので補完しない
" rustかつprevに'<'が含まれている場合はlifetimeの可能性が高いため補完しない
" カーソル位置に同じ文字がある場合は<Right>
" 直前と直後に空白や括弧しかない場合は補完する
" それ以外は補完しない
function! s:quotation_key (key) abort
  let [prev, post] = s:getline ()

  let res = s:closing_pair (prev, post, a:key)

  if &filetype ==# 'vim' && a:key ==# '"' && prev =~# '\v^\s*$'
    return res
  elseif &filetype ==# 'rust' && a:key ==# '''' && prev =~# '<'
    return res
  elseif a:key ==# '''' && prev =~# '\v\k$'
    return res
  else
    return res . s:opened_pair (prev . a:key, post, res ==# "\<Right>")
    let longest_end = s:find_matched_end (prev . a:key)

    if longest_end !=# '' && s:should_auto_complete (post)
    endif

    " カーソル直前が空文字 or 空白
    let left_flag = prev =~# '\v^$|\s$'
    " カーソル直下が空文字 or 空白
    let right_flag = post =~# '\v^$|^\s'

    " カーソル直前が括弧開き
    " (|
    for [begin, end] in s:parens
      if s:ends_with (prev, begin)
        let left_flag = 1
      endif

    " カーソル直下が括弧閉じ
    " |)
      if s:starts_with (post, end)
        let right_flag = 1
      endif
    endfor

    if left_flag == 1 && right_flag == 1
      return a:key . a:key . "\<Left>"
    else
      return a:key
    endif
  endif
endfunction

