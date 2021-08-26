scriptencoding utf-8

function! pack#minpac#init () abort
  augroup pack-minpac-on-init
    autocmd!
    autocmd FileType minpac,minpacprgs nnoremap <silent><buffer><nowait> q <Cmd>q<CR>
  augroup END
endfunction
