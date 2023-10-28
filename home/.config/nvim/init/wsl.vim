
augroup wsl-yank
  autocmd!
  autocmd TextYankPost * if v:event.regname ==# 'w' | call system ('iconv -f utf-8 -t cp932 | clip.exe', @w) | endif
augroup END

command! -bar GetWindowsClipboard let @" = join (systemlist ('powershell.exe get-clipboard | iconv -f cp932 | sed -z ''s/\r\n/\n/g'''), "\n")

nnoremap <Space>y "wy
xnoremap <Space>y "wy

nnoremap <Space>p <Cmd>GetWindowsClipboard<CR>p
xnoremap <Space>p <Cmd>GetWindowsClipboard<CR>p

nnoremap <Space>P <Cmd>GetWindowsClipboard<CR>P
xnoremap <Space>P <Cmd>GetWindowsClipboard<CR>P
