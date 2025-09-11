function! my_notify#notify (message, level = v:null, opt = {}) abort
  " call call(luaeval('vim.notify'), [a:message, v:null, a:opt])
  " lua vim.notify (vim.fn.eval('a:message'), nil, vim.fn.eval('a:opt'))
  call v:lua.vim.notify(a:message, a:level, a:opt)
endfunction

let s:levels = luaeval('vim.log.levels')

function! my_notify#debug (message, opt = {}) abort
  call my_notify#notify(a:message, s:levels.DEBUG, a:opt)
endfunction

function! my_notify#error (message, opt = {}) abort
  call my_notify#notify(a:message, s:levels.ERROR, a:opt)
endfunction

function! my_notify#info (message, opt = {}) abort
  call my_notify#notify(a:message, s:levels.INFO, a:opt)
endfunction

function! my_notify#trace (message, opt = {}) abort
  call my_notify#notify(a:message, s:levels.TRACE, a:opt)
endfunction

function! my_notify#warn (message, opt = {}) abort
  call my_notify#notify(a:message, s:levels.WARN, a:opt)
endfunction

function! my_notify#off (message, opt = {}) abort
  call my_notify#notify(a:message, s:levels.OFF, a:opt)
endfunction

function! my_notify#inspect (data, opt = {}) abort
  call my_notify#notify(v:lua.vim.inspect(a:data), v:null, a:opt)
endfunction
