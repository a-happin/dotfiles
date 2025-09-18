local terminal_extension = {
  sections = {
    lualine_a = {'mode'},
    lualine_b = {{'filename', file_status = false, path = 0, icon_enabled = false}},
  },
  filetypes = {'terminal'}
}

local function skkstatus ()
  local alias = {[''] = 'A', hira = 'あ', kata = 'ア', hankata = 'ｱ', zenkaku = "Ａ"}
  return alias[vim.g['skkeleton#mode']]
end

local function binary ()
  -- local bufnr = vim.api.nvim_get_current_buf ()
  -- if vim.bo[bufnr].binary
  if vim.bo.binary
  then
    return 'binary'
  else
    return ''
  end
end

local function location ()
  return '%3l,%-2v'
end

-- \x16 == <C-v>
local sectioncounttable = {v = true, V = true, ['\x16'] = true}
local function selectioncount()
  ---@type string
  local mode = vim.fn.mode()
  if not sectioncounttable[mode]
  then
    return ''
  end

  local region = vim.fn.getregion(vim.fn.getpos('v'), vim.fn.getpos('.'), {type = mode})
  local chars = 0
  for _, s in ipairs(region)
  do
    chars = vim.fn.strchars(s) + chars
  end

  -- add "\n" except <C-v>
  if mode ~= '\x16'
  then
    chars = chars + #region - 1
  end

  return string.format('%d lines, %d characters', #region, chars)
end

local function hash ()
  if vim.b.my_hash == nil
  then
      return ''
  else
    return string.format ('last_saved_hash = %s', vim.b.my_hash)
  end
end

local function my_pairs ()
  -- return '%{string (get (b:, "my_pairs", ""))}'
  if vim.b.my_pairs_stack == nil
  then
    return ''
  else
    return vim.inspect (vim.b.my_pairs_stack)
  end
end

local function lsp_clients ()
  local buf_clients = vim.lsp.get_clients({bufnr = 0})
  local res = {}
  for i, client in ipairs(buf_clients)
  do
    res[i] = client.name
  end
  return table.concat (res, ", ")
end

require 'lualine'.setup {
  options = {
    theme = 'ayu_mirage',
    always_divide_middle = true,
    globalstatus = true,
  },
  sections = {
    lualine_a = { 'mode', skkstatus },
    lualine_b = {{ 'filename', file_status = true, path = 1, icon_enabled = false }},
    lualine_c = { hash },
    lualine_x = {selectioncount, { 'diagnostics', sources = {'nvim_diagnostic'}, colored = true, symbols = { error = 'E:', warn = 'W:', info = 'I:', hint = 'H:' } }, { 'lsp_status', icon = '' }, my_pairs},
    lualine_y = { 'filetype' },
    lualine_z = { { 'fileformat', symbols = { unix = 'LF', dos = 'CRLF', mac = 'CR' } }, 'encoding', binary, location () },
  },
  extensions = { 'fern', 'quickfix', terminal_extension }
}
