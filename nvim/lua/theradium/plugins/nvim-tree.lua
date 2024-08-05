vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local nvimTree = require('nvim-tree')

nvimTree.setup({
  hijack_cursor = true,
  sync_root_with_cwd = true,
  select_prompts = true,
  sort = {
    sorter = "extension",
    folders_first = true,
  },
  view = {
    centralize_selection = true,
    cursorline = true,
    side = "left",
    number = true,
    relativenumber = true,
  },
  renderer = {
    indent_width = 3,
    indent_markers = {
      enable = true,
    },
    icons = {
      git_placement = "signcolumn"
    }
  },
  filters = {
    enable = true,
    git_ignored = false,
    dotfiles = false,
    custom = {}
  }
})

