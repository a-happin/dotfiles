scriptencoding utf-8

function! my#plugin#coc#hook_add () abort
  let g:coc_global_extensions = [
        \ 'coc-lists',
        \ 'coc-vimlsp',
        \ 'coc-json',
        \ 'coc-tsserver',
        \ 'coc-deno',
        \ 'coc-fish',
        \]
endfunction

function! my#plugin#coc#hook_post_source () abort
  " 定義ジャンプ
  nmap <silent> gd <Plug>(coc-definition)

  " 参照ジャンプ
  " grは元は仮想上書き
  nmap <silent> gr <Plug>(coc-references)

  " CocList
  " nnoremap <silent> <Space><Space> :<C-u>CocList<CR>

  " 次のdiagnostic(エラー、警告)
  nmap <silent> [e <Plug>(coc-diagnostic-prev)
  nmap <silent> ]e <Plug>(coc-diagnostic-next)

  nmap qf <Plug>(coc-fix-current)

  " show documentation
  nmap <F1> K
  nnoremap <silent> K <Cmd>call <SID>show_documentation ()<CR>


  " rename identifier
  nmap <F2> <Plug>(coc-rename)

  " 補完開始
  inoremap <silent><expr> <C-Space> coc#start()

  augroup coc-config
    autocmd!
    autocmd CursorHold * silent call CocActionAsync ('highlight')
  augroup END
endfunction

" show vim help
function! s:show_documentation () abort
  if (index (['vim', 'help'], &filetype) >= 0)
    execute 'help ' . expand ('<cword>')
  else
    call CocAction ('doHover')
  endif
endfunction
