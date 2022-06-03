" 挿入モードに入るが1文字入力したら即抜ける
function! mappings#insert_one ()
  augroup mappings-insert-one
    autocmd! * <buffer>
    autocmd TextChangedI <buffer> ++once stopinsert
    autocmd InsertLeave  <buffer> autocmd! mappings-insert-one * <buffer>
  augroup END
endfunction
