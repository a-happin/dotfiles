-- This module contains a number of default definitions
-- local rainbow_delimiters = require 'rainbow-delimiters'

-- vim.g.rainbow_delimiters = {
--     strategy = {
--         [''] = rainbow_delimiters.strategy['global'],
--         commonlisp = rainbow_delimiters.strategy['local'],
--     },
--     query = {
--         [''] = 'rainbow-delimiters',
--         lua = 'rainbow-blocks',
--     },
--     priority = {
--         [''] = 110,
--         lua = 210,
--     },
--     highlight = {
--         'RainbowRed',
--         'RainbowYellow',
--         'RainbowBlue',
--         'RainbowOrange',
--         'RainbowGreen',
--         'RainbowViolet',
--         'RainbowCyan',
--     },
-- }

local define_highlight = function ()
  vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
  vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
  vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
  vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
  vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
  vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
  vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })

  vim.api.nvim_set_hl (0, "RainbowRed2", { fg = "#bf616a" })
  vim.api.nvim_set_hl (0, "RainbowOrange2", { fg = "#d08770" })
  vim.api.nvim_set_hl (0, "RainbowYellow2", { fg = "#ebcb8b" })
  vim.api.nvim_set_hl (0, "RainbowGreen2", { fg = "#a3be8c" })
  vim.api.nvim_set_hl (0, "RainbowBlue2", { fg = "#5e81ac" })
  vim.api.nvim_set_hl (0, "RainbowViolet2", { fg = "#b48ead" })
end

--- @type fun(group: string, f: fun(autocmd: fun(event: string | string[], opts: {group: string | integer, pattern: string | string[], callback: (fun(_: any): any), buffer: integer, desc: string, command: string, once: boolean, nested: boolean }): number): nil): nil
local function augroup (group, f)
  vim.api.nvim_create_augroup (group, { clear = true })
  f (function (event, opts)
    opts = opts or {}
    opts.group = group
    return vim.api.nvim_create_autocmd (event, opts)
  end)
end
augroup ('fix-rainbow-delimiters', function (autocmd)
  autocmd ({"ColorScheme"}, {callback = define_highlight})
end)

-- vim.g.rainbow_delimiters = {
--     highlight = {
--         'RainbowRed',
--         'RainbowYellow',
--         'RainbowBlue',
--         'RainbowOrange',
--         'RainbowGreen',
--         'RainbowViolet',
--         'RainbowCyan',
--     },
-- }

vim.g.rainbow_delimiters = {
  highlight = {
    'RainbowRed2',
    'RainbowOrange2',
    'RainbowYellow2',
    'RainbowGreen2',
    'RainbowBlue2',
    'RainbowViolet2',
  }
}
