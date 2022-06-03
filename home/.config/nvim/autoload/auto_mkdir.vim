function! auto_mkdir#mkdir (dir, force) abort
  if empty (a:dir) || a:dir =~# '^\w\+://' || isdirectory (a:dir) || a:dir =~# '^suda:'
      return
  endif
  if !a:force
    echohl Question
    call inputsave ()
    let result = input (printf ('"%s" does not exist. Create? [y/N]', a:dir), '') =~? '\v^y%[es]$'
    call inputrestore ()
    echohl None
    if !result
      return
    endif
  endif
  call mkdir (a:dir, 'p')
endfunction
