local opts = { remap = false, silent = true }
local map = vim.keymap.set

local moden = "n"
local modei = "i"
local modex = "x"
local modenx = { "n", "x" }
local modeni = { "n", "i" }
local modenxi = { "n", "x", "i" }

vim.g.mapleader = " "
map("n", "<leader>pv", vim.cmd.Ex)

-- map(modenx, "d", '"_d', opts)
-- map(modenx, "D", '"_D', opts)

map(modenx, "x", '"_x', opts)
map(modenx, "X", '"_X', opts)

map(modenx, "c", '"_c', opts)
map(modenx, "C", '"_C', opts)

-- case conversion

map(modenx, "gl", "gu", opts)
map(modenx, "gu", "gU", opts)
map(moden, "<C-d>", '"ayy"ap', opts)

map(modenx, "<C-c>", "<Esc>", opts)
map(modei, "jj", "<Esc>", opts)

map(moden, "<C-j>", "<cmd>move +1<CR>", opts)
map(moden, "<C-k>", "<cmd>move -2<CR>", opts)

map(modex, "<C-j>", ":move '>+1<CR>gv", opts)
map(modex, "<C-k>", ":move '<-2<CR>gv", opts)

map(modex, ">", ">gv", opts)
map(modex, "<", "<gv", opts)

map(moden, "o", "o<Esc>", opts)
map(moden, "O", "O<Esc>", opts)

-- map(moden, "<CR>", "o<Esc>", opts)
-- map(moden, "<BS>", function()
--   local current_line = vim.api.nvim_get_current_line()
--   local is_whitespace = current_line:match("^%s*$") ~= nil
--   if is_whitespace then
--     vim.cmd("normal dd")
--   else
--     vim.cmd("normal! 0")
--   end
-- end, opts)

-- ================= PLUGINS ===============
-- telescope
local telescope = require('telescope.builtin')

vim.keymap.set(moden, '<C-p>', function()
  -- local status, _ = pcall(telescope.git_files)
  -- if not status then
  telescope.find_files()
  -- end
end)

-- nvim-tree
local nvimTree = require('nvim-tree.api')

map("n", "<leader>tt", function()
  nvimTree.tree.toggle()
end, opts)

map("n", "<leader>ti", function()
  nvimTree.tree.open({ find_file = true })
end, opts)

-- barbar (tabline)
map("n", "<M-C-Left>", "<cmd>BufferPrevious<CR>", opts)
map("n", "<M-C-Right>", "<cmd>BufferNext<CR>", opts)

