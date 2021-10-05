
function! plugin#fzf#init () abort
  " ripgrepによるファイル横断検索
  command! -nargs=* -bang Rg call s:ripgrep_fzf (<q-args>, <bang>0)
endfunction

function! s:ripgrep_fzf (query, fullscreen) abort
  let command_fmt = 'rg --hidden --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf (command_fmt, shellescape (a:query))
  let reload_command = printf (command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:' . reload_command]}
  call fzf#vim#grep (initial_command, 1, fzf#vim#with_preview (spec), a:fullscreen)
endfunction
