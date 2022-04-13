local lspconfig = require 'lspconfig'
local on_attach = function (_, bufnr)
  local function buf_set_keymap (...) vim.api.nvim_buf_set_keymap (bufnr, ...) end
  -- local function buf_set_option (...) vim.api.nvim_buf_set_option (bufnr, ...) end

  local opts = {noremap = true, silent = true}
  -- 次のdiagnostic(エラー, 警告)
  buf_set_keymap ('n', '[e', [[<Cmd>lua vim.diagnostic.goto_prev ()<CR>]], opts)
  buf_set_keymap ('n', ']e', [[<Cmd>lua vim.diagnostic.goto_next ()<CR>]], opts)
  -- 定義ジャンプ
  buf_set_keymap ('n', 'gd', [[<Cmd>lua vim.lsp.buf.definition ()<CR>]], opts)
  -- 参照ジャンプ(元は仮想上書き)
  buf_set_keymap ('n', 'gr', [[<Cmd>lua vim.lsp.buf.references ()<CR>]], opts)
  -- hover
  buf_set_keymap ('n', '<F1>', [[<Cmd>lua vim.lsp.buf.hover ()<CR>]], opts)
  buf_set_keymap ('n', 'K', [[<Cmd>lua vim.lsp.buf.hover ()<CR>]], opts)
  -- signature_help
  buf_set_keymap ('i', '<F1>', [[<Cmd>lua vim.lsp.buf.signature_help ()<CR>]], opts)
  -- rename
  buf_set_keymap ('n', '<F2>', [[<Cmd>lua vim.lsp.buf.rename ()<CR>]], opts)

  -- TODO: 動いてないので要調査
  vim.cmd [[
    augroup init-lspconfig
      autocmd! * <buffer>
      autocmd CursorHold <buffer> ++nested lua vim.lsp.buf.document_highlight ()
    augroup END
  ]]
end

local lsp_installer = require 'nvim-lsp-installer'

lsp_installer.settings ({
  ui = {
    icons = {
      server_installed = '✔ ',
      server_pending = '➜ ',
      server_uninstalled = '✘ ',
    },
  },
})

lsp_installer.on_server_ready (function (server)
  local opts = {}
  opts.on_attach = on_attach

  if server.name == 'sumneko_lua' then
    opts.settings = {
      Lua = {
        runtime = {version = 'LuaJIT', path = vim.split (package.path, ';')},
        diagnostics = {
          globals = {'vim'},
        },
      },
    }
  end

  server:setup (opts)
  vim.cmd [[ do User LspAttachBuffers ]]
end)


if (vim.fn.executable ('deno')) then
  lspconfig.denols.setup {
    on_attach = on_attach,
    init_options = {
      unstable = true,
    },
  }
end

if (vim.fn.executable ('ccls')) then
  lspconfig.ccls.setup {
    on_attach = on_attach,
    init_options = {
      cache = {
        directory = '/tmp/.ccls-cache',
      },
      clang = {
        extraArgs = {
          '-std=c++2b',
          '-Weverything',
          '-Wno-c++98-compat-pedantic',
          '-Wno-c11-extension',
          '-Wno-unused-macros',
          '-Wno-unused-const-variable',
          '-pedantic-errors',
          '-I./include',
        },
      },
    },
  }
end
