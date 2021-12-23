scriptencoding utf-8

function! plugin#coc#init () abort
  let g:coc_global_extensions = [
        \ 'coc-lists',
        \ 'coc-vimlsp',
        \ 'coc-json',
        \ 'coc-tsserver',
        \ 'coc-deno',
        \ 'coc-fish',
        \ 'coc-rust-analyzer',
        \]
  augroup pack-coc-on-init
    autocmd!
    autocmd User CocNvimInit ++once call s:on_init ()
  augroup END
endfunction

function! s:on_init () abort
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

  nmap <nowait><silent> qf <Plug>(coc-fix-current)

  " show documentation
  nnoremap <silent> <F1> <Cmd>call CocAction ('doHover')<CR>
  nnoremap <silent> K <Cmd>call <SID>show_documentation ()<CR>


  " rename identifier
  nmap <silent> <F2> <Plug>(coc-rename)

  " 補完開始
  inoremap <silent><expr> <C-Space> coc#refresh()

  augroup coc-config
    autocmd!
    autocmd CursorHold *? silent call CocActionAsync ('highlight')
    autocmd CursorHoldI *? if ! pumvisible () | silent call CocActionAsync ('showSignatureHelp') | endif
    autocmd User CocJumpPlaceholder silent call CocActionAsync ('showSignatureHelp')
  augroup END
endfunction

" show vim help
function! s:show_documentation () abort
  if (index (['vim', 'help'], &filetype) >= 0)
    execute 'help' expand ('<cword>')
  else
    call CocAction ('doHover')
  endif
endfunction

