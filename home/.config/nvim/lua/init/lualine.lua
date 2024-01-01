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
  local bufnr = vim.api.nvim_get_current_buf ()
  if vim.bo[bufnr].binary
  then
    return 'binary'
  else
    return ''
  end
end

local function location ()
  return '%3l,%-2v'
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
    lualine_x = {{ 'diagnostics', sources = {'nvim_diagnostic'}, colored = true, symbols = { error = 'E:', warn = 'W:', info = 'I:', hint = 'H:' } }, my_pairs},
    lualine_y = { 'filetype' },
    lualine_z = { { 'fileformat', symbols = { unix = 'LF', dos = 'CRLF', mac = 'CR' } }, 'encoding', binary, location () },
  },
  extensions = { 'fern', 'quickfix', terminal_extension }
}
