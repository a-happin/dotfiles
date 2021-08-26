scriptencoding utf-8

function! util#open (arg) abort
  if executable ('powershell.exe')
    call system ('powershell.exe start ' . a:arg)
  elseif executable ('open')
    call system ('open ' . a:arg)
  elseif executable ('xdg-open')
    call system ('xdg-open ' . a:arg)
  else
    echoerr "util#open: cannot open"
  endif
endfunction
