scriptencoding utf-8

" 最後に選択したテキストを取得
" - マルチバイト文字対応
" - Unicode合成文字を無視(https://ja.wikipedia.org/wiki/%E5%90%88%E6%88%90%E6%B8%88%E3%81%BF%E6%96%87%E5%AD%97)
" - selectionオプション対応
" 参考:
"   - https://stackoverflow.com/questions/1533565/how-to-get-visually-selected-text-in-vimscript (マルチバイト文字非対応)
"   - https://github.com/vim-jp/vital.vim/blob/master/autoload/vital/__vital__/Vim/Buffer.vim (selectionオプション非対応)
function! buffer#last_selected_text () abort
  if visualmode () ==# "\<C-v>"
    let save = getreg ('"', 1)
    let save_type = getregtype ('"')
    try
      normal! gv""y
      return @"
    finally
      call setreg ('"', save, save_type)
    endtry
  else
    let [line_start, col_start] = getpos ("'<")[1:2]
    let [line_end  , col_end  ] = getpos ("'>")[1:2]
    if line_start <= line_end
      let lines = getline (line_start, line_end)
      let lastchar = matchstr (lines[-1][col_end - 1 :], '.')
      let lines[-1] = lines[-1][: col_end - 2]
      let lines[0] = lines[0][col_start - 1 :]
      return join (lines, "\n") . (&selection ==# 'inclusive' ? lastchar : '') . (visualmode () ==# 'V' ? "\n" : '')
    else
      return ''
    endif
  endif
endfunction
