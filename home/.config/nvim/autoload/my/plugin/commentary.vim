scriptencoding utf-8

function! my#plugin#commentary#hook_post_source () abort
  nmap <C-_> gcc
  imap <C-_> <C-o>gcc
  xmap <C-_> gc
endfunction
