augroup encrypt
  autocmd!
  autocmd BufReadCmd *.encrypted call s:decrypt_read ()
  autocmd BufWriteCmd *.encrypted call s:encrypt_write ()
augroup END

function! s:decrypt_read () abort
  setlocal buftype=acwrite
  setlocal nobackup noswapfile noundofile

  if filereadable (bufname ())
    doautocmd <nomodeline> BufReadPre
    try
      call inputsave ()
      redraw | let password = inputsecret ('enter decryption password: ')
    finally
      call inputrestore ()
      redraw
    endtry
    " エラーになった場合はバッファの内容がエラーメッセージになるのでsilentしてよし！
    silent execute '%!openssl aes-256-cbc -d -iter 101011 -k' password '-in' shellescape (bufname ())
    setlocal nomodified
    doautocmd <nomodeline> BufReadPost
  endif
endfunction

function! s:encrypt_write () abort
  setlocal buftype=acwrite
  setlocal nobackup noswapfile noundofile

  doautocmd <nomodeline> BufWritePre
  try
    call inputsave ()
    redraw | let password = inputsecret ('enter encryption password: ')
    redraw | let password2 = inputsecret ('Verifying - enter encryption password: ')
  finally
    call inputrestore ()
    redraw
  endtry
  if password ==# password2
    let res = execute (printf ('write !openssl aes-256-cbc -e -iter 101011 -k %s -out %s', password, shellescape (bufname ())))
    if v:shell_error
      call s:echo_err (res)
    else
      setlocal nomodified
      doautocmd <nomodeline> BufModifiedSet
      doautocmd <nomodeline> BufWritePost
    endif
  else
    call s:echo_err ('password doesn''t match')
  endif
endfunction

function! s:echo_err (msg) abort
  redraw
  echohl ErrorMsg
  for line in split (a:msg, '\n')
    echomsg printf ('[encrypt] %s', line)
  endfor
  echohl None
endfunction
