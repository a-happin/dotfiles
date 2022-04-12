scriptencoding utf-8

function! plugin#lightline#init () abort
  let g:lightline = {
        \   'colorscheme': 'wombat',
        \   'enable': {'tabline': 0},
        \   'active': {
        \     'left': [
        \       ['mode', 'paste'],
        \       ['readonly', 'absolutepath', 'modified']
        \     ],
        \     'right': [
        \       ['lineinfo'],
        \       ['percent'],
        \       ['fileformat', 'fileencoding', 'filetype'],
        \     ]
        \   },
        \   'tab': {
        \     'active': ['filename', 'modified'],
        \     'inactive': ['filename', 'modified']
        \   }
        \ }
  " call lightline#coc#register ()
endfunction
