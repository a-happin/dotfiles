-- https://foo-x.com/blog/wsl-clipboard/
-- powershell.exe -command '[Console]::InputEncoding = [System.Text.Encoding]::UTF8; $reader = [System.IO.StreamReader]::new([System.IO.Stream]::Synchronized([System.Console]::OpenStandardInput())); $reader.ReadToEnd() | Set-Clipboard'
-- Read-Host は文字数制限があるらしい

local copy = {'powershell.exe', '-c', [==[[Console]::InputEncoding = [System.Text.Encoding]::UTF8; $reader = [System.IO.StreamReader]::new([System.IO.Stream]::Synchronized([System.Console]::OpenStandardInput())); $reader.ReadToEnd() | Set-Clipboard]==]}
local paste = {'powershell.exe', '-c', [==[[Console]::OutputEncoding = [System.Text.Encoding]::UTF8;[Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))]==]}

-- local uv = vim.uv or vim.loop
-- local clipboard_manager = {}
-- clipboard_manager

-- local copy = function (lines, regtype)
--   vim.notify(vim.inspect {lines = lines, regtype = regtype})
-- end
-- vim.system

vim.g.clipboard = {
  name = 'my_wsl_clipboard',
  copy = {
    -- ['+'] = 'clip.exe',
    -- ['*'] = 'clip.exe',
    ['+'] = copy,
    ['*'] = copy,
  },
  paste = {
    ['+'] = paste,
    ['*'] = paste,
  },
  cache_enabled = 1,
}

-- https://neovim.io/doc/user/faq.html#faq
if vim.g.loaded_clipboard_provider
then
  vim.g.loaded_clipboard_provider = nil
  vim.cmd [[
    runtime autoload/provider/clipboard.vim
  ]]
    -- echomsg "clipboard reload"
end
