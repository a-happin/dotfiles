local lspconfig = require 'lspconfig'
local mason = require 'mason'
local mason_lspconfig = require 'mason-lspconfig'

-- not to move cursor into floating window
-- focus=falseだけならマウスでスクロールできる、focusable=falseはできない
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with (vim.lsp.handlers.hover, { focus = false, border = 'rounded' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with (vim.lsp.handlers.signature_help, { focusable = false, border = 'rounded' })
vim.diagnostic.config {
  float = {
    border = 'rounded'
  }
}

vim.cmd [[
  autocmd! ColorScheme * highlight FloatBorder ctermfg=224 ctermbg=0 guifg=#f6adc6 guibg=#000000
]]

local on_attach = function (client, bufnr)
  local function buf_set_keymap (...) vim.api.nvim_buf_set_keymap (bufnr, ...) end
  local function buf_set_option (...) vim.api.nvim_buf_set_option (bufnr, ...) end

  local opts = {noremap = true, silent = true, buffer = bufnr}
  -- 次のdiagnostic(エラー, 警告)
  vim.keymap.set ('n', '[e', vim.diagnostic.goto_prev, opts)
  vim.keymap.set ('n', ']e', vim.diagnostic.goto_next, opts)
  -- 定義ジャンプ
  vim.keymap.set ('n', 'gd', vim.lsp.buf.definition, opts)
  -- 参照ジャンプ(元は仮想上書き)
  vim.keymap.set ('n', 'gr', vim.lsp.buf.references, opts)
  -- hover
  vim.keymap.set ('n', '<F1>', vim.lsp.buf.hover, opts)
  vim.keymap.set ('n', 'K', vim.lsp.buf.hover, opts)
  -- signature_help
  vim.keymap.set ('i', '<F1>', vim.lsp.buf.signature_help, opts)
  -- rename
  vim.keymap.set ('n', '<F2>', vim.lsp.buf.rename, opts)
  -- code_action
  -- vim.keymap.set ('n', 'qf', vim.lsp.buf.code_action, opts)
  vim.keymap.set ('n', '<Space>c', vim.lsp.buf.code_action, opts)

  if client.server_capabilities.documentHighlightProvider then
    vim.cmd [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight ()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references ()
      augroup END
    ]]
  end
end

-- local node_root_dir = lspconfig.util.root_pattern ('package.json', 'node_modules')
-- local buf_name = vim.api.nvim_buf_get_name(0) == '' and vim.fn.getcwd() or vim.api.nvim_buf_get_name(0)
-- local current_buf = vim.api.nvim_get_current_buf ()
-- local is_node_repo = node_root_dir(buf_name, current_buf) ~= nil

mason.setup {
  ui = {
    border = 'rounded',
    icons = {
      package_installed = '✔ ',
      package_pending = '➜ ',
      package_uninstalled = '✘ ',
    },
  },
}
mason_lspconfig.setup {
  ensure_installed = { 'vimls', 'jsonls', 'lua_ls' }
}

for _, server in ipairs(mason_lspconfig.get_installed_servers ()) do
  local opts = {}
  opts.on_attach = on_attach

  if server == 'lua_ls' then
    opts.settings = {
      Lua = {
        runtime = {version = 'LuaJIT', path = vim.split (package.path, ';')},
        diagnostics = {
          enable = true,
          globals = {'vim'},
        },
        workspace = {
          library = { vim.env.VIMRUNTIME }
          -- library = vim.api.nvim_list_runtime_paths ()
        },
      },
    }
  end

  lspconfig[server].setup (opts)
end
-- lsp_installer.on_server_ready (function (server)
-- end)


local function root_pattern_or_dirname(...)
  local patterns = { ... }
  return function (filename)
    return lspconfig.util.root_pattern (unpack (patterns)) (filename) or lspconfig.util.path.dirname (filename)
  end
end

if (vim.fn.executable ('deno')) then
  lspconfig.denols.setup {
    on_attach = on_attach,
    root_dir = root_pattern_or_dirname ('deno.json', 'deno.jsonc'),
    init_options = {
      lint = false,
      unstable = true,
    },
  }
end

if (vim.fn.executable ('ccls')) then
  lspconfig.ccls.setup {
    root_dir = root_pattern_or_dirname ('.ccls', 'compile_commands.json', '.git'),
    on_attach = on_attach,
    init_options = {
      cache = {
        directory = '/tmp/.ccls-cache',
      },
      clang = {
        extraArgs = {
          '-std=c++2b',
          -- '-stdlib=libc++',
          '-Weverything',
          '-Wno-c++98-compat-pedantic',
          '-Wno-c11-extension',
          '-Wno-unused-macros',
          '-Wno-unused-const-variable',
          '-Wno-unsafe-buffer-usage',
          '-pedantic-errors',
          '-I./include',
        },
      },
    },
  }
end
