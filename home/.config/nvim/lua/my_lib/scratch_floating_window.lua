
local M = {}

local augroup = require ('my_lib/augroup')

-- (width,height) < 0 なら -rateとして、 割合設定を行う
--- @param opts {width: number, height: number, border?: any}
local function centering(opts)
  local ui = vim.api.nvim_list_uis()[1]

  -- border size (double)
  local bs = opts.border and 2 or 0

  --- floor(max_width - (border_size * 2本) * rate)
  local width = opts.width < 0 and math.floor ((bs - ui.width) * opts.width) or opts.width
  local height = opts.height < 0 and math.floor ((bs - ui.height) * opts.height) or opts.height

  local col = math.floor ((ui.width - width) / 2)
  local row = math.floor ((ui.height - height) / 2)

  return vim.tbl_extend ('force', opts, {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
  })
end


-- optsをdir方向にrで分割して[opts,opts]を返す
--- @param dir 'horizontal' | 'vertical'
--- @param r number `|r|<1`なら割合として設定, それ以外なら文字数として設定. `r<0` なら後ろから設定, それ以外なら前から設定
--- @param opts {width: number, height: number, col: number, row: number, border?: any}
local function split_layout(dir, r, opts)
  -- local key = ({
  --   horizontal = 'width',
  --   vertical = 'height',
  -- }) [dir]

  local key
  local offsetkey

  if dir == 'horizontal'
  then
    key = 'width'
    offsetkey = 'col'
  elseif dir == 'vertical'
  then
    key = 'height'
    offsetkey = 'row'
  else
    assert (key, 'direction should be horizontal or vertical')
  end

  local absr = math.abs(r)

  -- border size (double)
  local bs = opts.border and 2 or 0
  vim.notify(vim.inspect(bs))

  local m = opts[key] - bs
  local a = absr < 1 and math.floor (m * absr) or absr
  local b = m - a

  if r < 0
  then
    -- swap
    a,b = b,a
  end

  return {
    vim.tbl_extend ('force', opts, {[key] = a}),
    vim.tbl_extend ('force', opts, {[key] = b, [offsetkey] = opts[offsetkey] + a + bs}),
  }
end

--- @param winopts vim.api.keyset.win_config
local function aaa (winopts)
  local buf = vim.api.nvim_create_buf(false, true)
  -- bufhidden=hideとしておいて、あとでbdeleteで消すのが定石？？
  vim.bo[buf].bufhidden = 'hide'

  vim.bo[buf].buftype = 'prompt'
  vim.fn.prompt_setprompt (buf, "> ")

  -- 内容set
  -- vim.api.nvim_buf_set_lines (buf, 0, -1, true, { 'test', 'text' })

  --- @type string | nil res
  local res

  -- define as closure
  local function close ()
    vim.api.nvim_buf_delete (buf, { force = true })
    -- vim.api.nvim_win_close (win, false)
    vim.notify (vim.inspect ({ res = res }))
  end


  --- @type vim.api.keyset.win_config
  local opts = vim.tbl_extend ('force', {
    -- border = 'rounded',
    -- relative = 'cursor',
    -- width = 10,
    -- height = 2,
    -- col = 0,
    -- row = 1,
    -- anchor = 'NW',
    style = 'minimal',
    title = ' hoge ',
    title_pos = 'center',
    zindex = 1,
  }, winopts)
  local win = vim.api.nvim_open_win (buf, false, opts)
  -- vim.wo[win].wrap = false
  vim.api.nvim_set_option_value ('winhl', 'NormalFloat:Normal,FloatBorder:Normal,FloatTitle:Normal', {win = win})

  vim.fn.prompt_setcallback (buf, function (x)
    res = x
    -- vim.notify (x)
    -- close()
    vim.api.nvim_win_close (win, false)
  end)

  local action_close = function ()
    -- vim.bo[buf].modified = false
    vim.notify ('action_close')
    close()
  end

  augroup ('MyFloatingWindow', function (autocmd)
    autocmd ('BufLeave', {
      buffer = buf,
      nested = true,
      once = true,
      callback = action_close,
    })
  end)

  vim.keymap.set ('i', '<Esc>', close, { buffer = buf })

  vim.cmd.startinsert ()

  vim.notify (vim.inspect (vim.tbl_extend ('force', opts, { win = win })))

  -- local s = split_layout ('horizontal', 0.5, opts)
  -- vim.notify (vim.inspect (s))

end

local bbb = centering ({ width = -0.9, height = -0.9, border = 'rounded' })
local ccc = split_layout ('vertical', -1, bbb)
aaa(ccc[1])
aaa(ccc[2])
-- aaa (bbb)
