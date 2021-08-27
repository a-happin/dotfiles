scriptencoding utf-8

function! init#source (file) abort
  execute 'source ' . $XDG_CONFIG_HOME . '/nvim/' . a:file
endfunction
