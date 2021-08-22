scriptencoding utf-8

function! my#plugin#fern#hook_add () abort
  let g:fern#default_hidden=1
  nnoremap <C-e> <Cmd>Fern . -reveal=% -drawer -toggle<CR>
endfunction
