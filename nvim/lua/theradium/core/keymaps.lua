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

-- ================= PLUGINS ===============

-- telescope
local telescope = require('telescope.builtin')

vim.keymap.set(moden, '<C-p>', function()
  -- local status, _ = pcall(telescope.git_files)
  -- if not status then
  telescope.find_files()
  -- end
end)


