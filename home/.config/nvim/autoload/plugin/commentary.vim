function! plugin#commentary#init () abort
  nmap <C-_> <Plug>CommentaryLine
  xmap <C-_> <Plug>Commentary
  imap <C-_> <C-o><Plug>CommentaryLine
endfunction
