require 'nvim-treesitter.configs'.setup {
  auto_install = false,

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

  ensure_installed = {'bash', 'c', 'cpp', 'css', 'fish', 'haskell', 'html', 'java', 'javascript', 'json', 'lua', 'make', 'markdown', 'rust', 'typescript', 'vim', 'yaml'},

}
