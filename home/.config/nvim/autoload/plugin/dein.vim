scriptencoding utf-8

" utilities for dein.vim

function! plugin#dein#force_reload () abort
  call dein#clear_state ()
  source $MYVIMRC
endfunction

function! plugin#dein#clear_all () abort
  call delete ($XDG_CACHE_HOME . '/dein', 'rf')
endfunction

function! plugin#dein#check_and_uninstall () abort
  let unused_plugins = dein#check_clean ()
  if empty (unused_plugins)
    echo 'nothing to do'
  else
    call map (unused_plugins, "delete(v:val, 'rf')")
    call dein#recache_runtimepath ()
  endif
endfunction
