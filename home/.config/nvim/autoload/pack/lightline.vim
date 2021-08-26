scriptencoding utf-8

function! pack#lightline#init () abort
  let g:lightline = {
        \   'colorscheme': 'wombat',
        \   'enable': {'tabline': 0},
        \   'active': {
        \     'left': [
        \       ['mode', 'paste'],
        \       ['readonly', 'absolutepath', 'modified']
        \     ],
        \     'right': [
        \       ['coc_errors', 'coc_warnings', 'coc_info', 'coc_hints', 'coc_hints'],
        \       ['lineinfo'],
        \       ['percent'],
        \       ['fileformat', 'fileencoding', 'filetype'],
        \       ['coc_status']
        \     ]
        \   },
        \   'tab': {
        \     'active': ['filename', 'modified'],
        \     'inactive': ['filename', 'modified']
        \   }
        \ }
endfunction
