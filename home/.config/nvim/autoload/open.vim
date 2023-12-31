function! open#open (arg) abort
  let arg = shellescape (a:arg)
  if executable ('powershell.exe')
    return system ('powershell.exe start ' . arg)
  elseif executable ('open')
    call system ('open ' . arg)
  elseif executable ('xdg-open')
    return system ('xdg-open ' . arg)
  else
    echoerr 'open#open: cannot open' . a:arg
  endif
endfunction

function! s:encodeURIComponent (x) abort
  return denops#request ('util', 'encodeURIComponent', [a:x])
endfunction

function! open#google (arg) abort
  return open#open ('https://www.google.com/search?q=' . s:encodeURIComponent (a:arg))
endfunction

function! open#gf () abort
  let url = expand ('<cfile>')
  if url =~# '\v^https?://'
    call open#open (url)
  else
    normal! gF
  endif
endfunction

" buffer#last_selected_textがバグってて正しい範囲を取得できない
function! open#gf_v () abort
  let url = buffer#last_selected_text ()
  if url =~# '\v^https?://'
    call open#open(url)
  else
    normal! gvgF
  endif
endfunction
