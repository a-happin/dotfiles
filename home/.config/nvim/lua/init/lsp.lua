-- local lspconfig = require 'lspconfig'
local mason = require 'mason'
local mason_lspconfig = require 'mason-lspconfig'

vim.diagnostic.config {
  float = {
    border = 'rounded'
  },
  virtual_text = {
    format = function (diagnostic)
      if diagnostic.code then
        return string.format ('%s (%s: %s)', diagnostic.message, diagnostic.source, diagnostic.code)
      else
        return string.format ('%s (%s)', diagnostic.message, diagnostic.source)
      end
    end
  },
  severity_sort = true
}

vim.cmd [[
  autocmd! ColorScheme * highlight FloatBorder ctermfg=224 ctermbg=0 guifg=#f6adc6 guibg=#000000
  highlight FloatBorder ctermfg=224 ctermbg=0 guifg=#f6adc6 guibg=#000000
]]

local function diagnostic_goto_prev ()
  return vim.diagnostic.jump { count = -1, float = true }
end
local function diagnostic_goto_next ()
  return vim.diagnostic.jump { count = 1, float = true }
end
-- not to move cursor into floating window
-- focus=falseだけならマウスでスクロールできる、focusable=falseはできない
local function my_lsp_hover ()
  return vim.lsp.buf.hover { focus = false, border = 'rounded' }
end

local function my_signature_help ()
  return vim.lsp.buf.signature_help { focusable = false, border = 'rounded' }
end

local on_attach = function (client, bufnr)
  -- local function buf_set_keymap (...) vim.api.nvim_buf_set_keymap (bufnr, ...) end
  -- local function buf_set_option (...) vim.api.nvim_buf_set_option (bufnr, ...) end

  local opts = {noremap = true, silent = true, buffer = bufnr}
  -- 次のdiagnostic(エラー, 警告)
  vim.keymap.set ('n', '[e', diagnostic_goto_prev, opts)
  vim.keymap.set ('n', ']e', diagnostic_goto_next, opts)
  -- 定義ジャンプ
  vim.keymap.set ('n', 'gd', vim.lsp.buf.definition, opts)
  -- 参照ジャンプ(元は仮想上書き)
  vim.keymap.set ('n', 'gr', vim.lsp.buf.references, opts)
  -- hover
  -- not to move cursor into floating window
  -- focus=falseだけならマウスでスクロールできる、focusable=falseはできない
  vim.keymap.set ('n', '<F1>', my_lsp_hover, opts)
  vim.keymap.set ('n', 'K', my_lsp_hover, opts)
  -- signature_help
  vim.keymap.set ('i', '<F1>', my_signature_help, opts)
  -- rename
  vim.keymap.set ('n', '<F2>', vim.lsp.buf.rename, opts)
  -- code_action
  -- vim.keymap.set ('n', 'qf', vim.lsp.buf.code_action, opts)
  vim.keymap.set ('n', '<Space>c', vim.lsp.buf.code_action, opts)

  if client:supports_method('textDocument/completion')
  then
    -- Optional: trigger autocompletion on EVERY keypress. May be slow!
    -- local chars = {}; for i = 32, 126 do table.insert (chars, string.char(i)) end
    -- client.server_capabilities.completionProvider.triggerCharacters = chars
    vim.lsp.completion.enable (true, client.id, bufnr, {autotrigger = true})
  end

  if client.server_capabilities.lspconfigdocumentHighlightProvider then
    vim.cmd [[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight ()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references ()
      augroup END
    ]]
  end
end

-- vim.lsp.config ('*', {on_attach = on_attach})

vim.api.nvim_create_autocmd ('LspAttach', {
  group = vim.api.nvim_create_augroup ('my.lsp', {}),
  callback = function (args)
    local client = assert (vim.lsp.get_client_by_id (args.data.client_id))
    on_attach (client, args.buf)
  end,
})

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
  -- opts.on_attach = on_attach

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

  -- lspconfig[server].setup (opts)
end
-- vim.lsp.enable (mason_lspconfig.get_installed_servers ())
-- lsp_installer.on_server_ready (function (server)
-- end)


vim.lsp.config ('lua_ls', {
  settings = {
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
})


-- local function root_pattern_or_dirname(...)
--   local patterns = { ... }
--   return function (filename)
--     return lspconfig.util.root_pattern (unpack (patterns)) (filename) or lspconfig.util.path.dirname (filename)
--   end
-- end

if (vim.fn.executable ('deno')) then
  -- vim.lsp.config ('denols', {
  --   on_attach = on_attach,
  --   init_options = {
  --     lint = false,
  --     unstable = false,
  --   },
  -- })
  vim.lsp.enable ('denols')
  -- lspconfig.denols.setup {
  --   on_attach = on_attach,
  --   root_dir = root_pattern_or_dirname ('deno.json', 'deno.jsonc'),
  --   init_options = {
  --     lint = false,
  --     unstable = true,
  --   },
  -- }
end

if (vim.fn.executable ('ccls')) then
  vim.lsp.config ('ccls', {
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
  })
  vim.lsp.enable ('ccls')
--   lspconfig.ccls.setup {
--     root_dir = root_pattern_or_dirname ('.ccls', 'compile_commands.json', '.git'),
--     on_attach = on_attach,
--     init_options = {
--       cache = {
--         directory = '/tmp/.ccls-cache',
--       },
--       clang = {
--         extraArgs = {
--           '-std=c++2b',
--           -- '-stdlib=libc++',
--           '-Weverything',
--           '-Wno-c++98-compat-pedantic',
--           '-Wno-c11-extension',
--           '-Wno-unused-macros',
--           '-Wno-unused-const-variable',
--           '-Wno-unsafe-buffer-usage',
--           '-pedantic-errors',
--           '-I./include',
--         },
--       },
--     },
--   }
end
