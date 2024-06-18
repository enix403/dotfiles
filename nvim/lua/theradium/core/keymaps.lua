vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- ================= PLUGINS ===============

-- telescope
local telescope = require('telescope.builtin')

vim.keymap.set('n', '<C-p>', function()
  local status, _ = pcall(telescope.git_files)
  if not status then
    telescope.find_files()
  end
end)


