require 'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
  },

  indent = {
    enable = true,
    disable = {'cpp'},
  },

  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      },
    },
  },

  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = 1000,
  },

  ensure_installed = {'bash', 'c', 'cmake', 'cpp', 'css', 'fish', 'go', 'haskell', 'help', 'html', 'http', 'java', 'javascript', 'jsdoc', 'json', 'kotlin', 'latex', 'llvm', 'lua', 'make', 'markdown', 'ninja', 'perl', 'php', 'python', 'regex', 'ruby', 'rust', 'scss', 'toml', 'typescript', 'vim', 'yaml'},
}
