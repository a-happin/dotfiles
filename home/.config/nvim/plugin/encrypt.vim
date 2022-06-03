augroup encrypt
  autocmd!
  autocmd BufReadPre *.encrypted setlocal buftype=acwrite
  autocmd BufReadCmd *.encrypted call s:decrypt_read ()
  autocmd BufWriteCmd *.encrypted call s:encrypt_write ()
augroup END

function! s:decrypt_read () abort
  try
    call inputsave ()
    redraw | let password = inputsecret ('enter decryption password: ')
  finally
    call inputrestore ()
    redraw
  endtry
  execute '%!openssl aes-256-cbc -d -iter 100 -k' password '-in' shellescape (bufname ())
endfunction

function! s:encrypt_write () abort
  try
    call inputsave ()
    redraw | let password = inputsecret ('enter encryption password: ')
    redraw | let password2 = inputsecret ('Verifying - enter encryption password: ')
  finally
    call inputrestore ()
    redraw
  endtry
  if password ==# password2
    execute 'write !openssl aes-256-cbc -e -iter 100 -k' password '-out' shellescape (bufname ())
    setlocal nomodified
  else
    echomsg 'password doesn''t match'
  endif
endfunction
