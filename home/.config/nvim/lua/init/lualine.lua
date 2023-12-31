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

require 'lualine'.setup {
  options = {
    theme = 'ayu_mirage',
    always_divide_middle = true,
    globalstatus = true,
  },
  sections = {
    lualine_a = { 'mode', skkstatus },
    lualine_b = {{ 'filename', file_status = true, path = 1, icon_enabled = false }},
    lualine_c = { '%{"hash = "}%{get (b:, "my_hash", "")}' },
    lualine_x = {{ 'diagnostics', sources = {'nvim_diagnostic'}, colored = true, symbols = { error = 'E:', warn = 'W:', info = 'I:', hint = 'H:' } }, '%{string (get (b:, "my_pairs_completion_stack", ""))}', '%{string (get (b:, "completion2", ""))}'},
    lualine_y = { 'filetype' },
    lualine_z = { { 'fileformat', symbols = { unix = 'LF', dos = 'CRLF', mac = 'CR' } }, 'encoding', binary, location () },
  },
  extensions = { 'fern', 'quickfix', terminal_extension }
}
