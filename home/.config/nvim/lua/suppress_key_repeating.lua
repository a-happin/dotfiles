local M = {}

M.key_state = {}

-- リピート間隔。(1000 / FPS)が望ましい
M.interval = 1000 / 20

M.suppress_key_repeating = function (key)
  -- is macro
  if vim.fn.reg_recording () ~= '' or vim.fn.reg_executing () ~= ''
  then
    return key
  elseif M.key_state[key] == nil
  then
    M.key_state[key] = true
    local timer = vim.loop.new_timer ()
    timer:start (M.interval, 0, function ()
      timer:stop ()
      timer:close ()
      M.key_state[key] = nil
    end)
    return key
  else
    return ""
  end
end

return M
