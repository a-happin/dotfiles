
function! s:add_digraph (chars, digraph) abort
  execute 'digraphs' a:chars char2nr (a:digraph)
endfunction

call s:add_digraph ('j.', '。')
call s:add_digraph ('j,', '、')
call s:add_digraph ('j!', '！')
call s:add_digraph ('j?', '？')
call s:add_digraph ('j/', '・')
call s:add_digraph ('j-', 'ー')
call s:add_digraph ('j~', '〜')

call s:add_digraph ('j(', '（')
call s:add_digraph ('j)', '）')
call s:add_digraph ('j[', '「')
call s:add_digraph ('j]', '」')
call s:add_digraph ('j{', '『')
call s:add_digraph ('j}', '』')
call s:add_digraph ('j<', '【')
call s:add_digraph ('j>', '】')

call s:add_digraph ('zh', '←')
call s:add_digraph ('zj', '↓')
call s:add_digraph ('zk', '↑')
call s:add_digraph ('zl', '→')
call s:add_digraph ('z.', '…')
call s:add_digraph ('z[', '『')
call s:add_digraph ('z]', '』')
call s:add_digraph ('z-', '〜')

call s:add_digraph ('zz', '💤')

