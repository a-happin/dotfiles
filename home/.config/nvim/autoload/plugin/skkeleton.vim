function! plugin#skkeleton#init () abort
  let g:skkeleton#mode = ''
  imap <C-j> <Plug>(skkeleton-toggle)
  cmap <C-j> <Plug>(skkeleton-toggle)
  autocmd User skkeleton-initialize-pre call skkeleton#config({"eggLikeNewline": v:true, "keepState": v:true , "useSkkServer": v:false})

  function! s:skkeleton_init_kanatable() abort
    call skkeleton#register_kanatable('rom', {
      \ "z\<Space>": ["\u3000", ''],
      \ "x-": ['―', ''],
      \ "<<": ['《', ''],
      \ ">>": ['》', ''],
      \ "~": ['〜', ''],
      \ "(": ['（', ''],
      \ ")": ["）", ''],
      \ "z|": ['｜', ''],
    \ })
  endfunction

  augroup skkeleton-user
    autocmd!
    autocmd User skkeleton-initialize-post call s:skkeleton_init_kanatable ()
    autocmd User skkeleton-mode-changed redrawstatus
  augroup END
endfunction
