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
    adaptive_size = true
  },
  renderer = {
    root_folder_label = function(path)
      return string.upper(vim.fn.fnamemodify(path, ":t"))  -- Convert the basename to uppercase
    end,
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
    custom = {
      '^.git$',
      '^node_modules$',
      '^.venv$',
      '^__pycache__$',
      '^.DS_Store$',
      -- 'dist',
      -- 'build',
    },
  }
})

