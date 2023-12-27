local notify = require "notify"
notify.setup { background_colour = "#000000", stages = "slide" }
vim.notify = notify

--- @type fun(group: string, f: fun(autocmd: fun(event: string | string[], opts: {group: string | integer, pattern: string | string[], callback: (fun(_: any): any), buffer: integer, desc: string, command: string, once: boolean, nested: boolean }): number): nil): nil
local function augroup (group, f)
  vim.api.nvim_create_augroup (group, { clear = true })
  f (function (event, opts)
    opts = opts or {}
    opts.group = group
    return vim.api.nvim_create_autocmd (event, opts)
  end)
end

local function define_highlight ()
vim.cmd [[
    highlight link NotifyBackground Pmenu
    highlight NotifyERRORBorder guifg=#8A1F1F guibg=#000000
    highlight NotifyWARNBorder guifg=#79491D guibg=#000000
    highlight NotifyINFOBorder guifg=#4F6752 guibg=#000000
    highlight NotifyDEBUGBorder guifg=#8B8B8B guibg=#000000
    highlight NotifyTRACEBorder guifg=#4F3552 guibg=#000000
    highlight NotifyERRORIcon guifg=#F70067 guibg=#000000
    highlight NotifyWARNIcon guifg=#F79000 guibg=#000000
    highlight NotifyINFOIcon guifg=#A9FF68 guibg=#000000
    highlight NotifyDEBUGIcon guifg=#8B8B8B guibg=#000000
    highlight NotifyTRACEIcon guifg=#D484FF guibg=#000000
    highlight NotifyERRORTitle guifg=#F70067 guibg=#000000
    highlight NotifyWARNTitle guifg=#F79000 guibg=#000000
    highlight NotifyINFOTitle guifg=#A9FF68 guibg=#000000
    highlight NotifyDEBUGTitle guifg=#8B8B8B guibg=#000000
    highlight NotifyTRACETitle guifg=#D484FF guibg=#000000
    highlight link NotifyERRORBody NotifyBackground
    highlight link NotifyWARNBody NotifyBackground
    highlight link NotifyINFOBody NotifyBackground
    highlight link NotifyDEBUGBody NotifyBackground
    highlight link NotifyTRACEBody NotifyBackground
]]
end

augroup ('fix-notify-color', function (autocmd)
  autocmd ({"ColorScheme"}, { callback = define_highlight })
end)
define_highlight ()
