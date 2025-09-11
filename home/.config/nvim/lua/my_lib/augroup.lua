--- @param group string
--- @param f fun(autocmd: fun(events: string | string[], opts: vim.api.keyset.create_autocmd): any)
local function augroup (group, f)
  vim.api.nvim_create_augroup (group, { clear = true })
  f (function (events, opts)
    opts = opts or {}
    opts.group = group
    return vim.api.nvim_create_autocmd (events, opts)
  end)
end

return augroup
