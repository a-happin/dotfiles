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

require 'lualine'.setup {
  options = {
    theme = 'ayu_mirage',
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode', skkstatus},
    lualine_b = {{'filename', file_status = true, path = 1, icon_enabled = false}},
    lualine_c = {},
    lualine_x = {{ 'diagnostics', sources = {'nvim_diagnostic'}, colored = true, symbols = { error = 'E:', warn = 'W:', info = 'I', hint = 'H:' } }},
    lualine_y = { 'filetype', { 'encoding', separator = ' ', padding = { left = 1, right = 0 } }, {'fileformat', symbols = {unix = 'LF', dos = 'CRLF', mac = 'CR'}} },
    lualine_z = {{'location', separator = ''}, {'progress', padding = {left = 0, right = 1}}},
  },
  extensions = {'fern', terminal_extension}
}

