scriptencoding utf-8

function! open#open (arg) abort
  if executable ('powershell.exe')
    call system ('powershell.exe start ' . a:arg)
  elseif executable ('open')
    call system ('open ' . a:arg)
  elseif executable ('xdg-open')
    call system ('xdg-open ' . a:arg)
  else
    echoerr "open#open: cannot open"
  endif
endfunction

function! s:URIEncoding ()

endfunction

function! open#google (arg) abort
  return open#open ('https://www.google.com/search?q=' . a:arg)
endfunction
