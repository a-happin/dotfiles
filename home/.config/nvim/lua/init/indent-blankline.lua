local ibl = require "ibl"

local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}
local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

-- vim.g.rainbow_delimiters = { highlight = highlight }

-- 現在のスコープもカラフルに表示する
-- ibl.setup { indent = { highlight = highlight }, scope = { highlight = highlight } }
-- カラフルかつアンダーラインを無効化する
-- ibl.setup { indent = { highlight = highlight }, scope = { enabled = false } }
-- 現在のスコープの色はデフォルト(灰色？)で表示する
-- ibl.setup { indent = { highlight = highlight } }
-- 現在のスコープの色はデフォルト(灰色？)で表示かつアンダーラインを無効化する
-- ibl.setup { indent = { highlight = highlight }, scope = { show_start = false, show_end = false } }


-- hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

