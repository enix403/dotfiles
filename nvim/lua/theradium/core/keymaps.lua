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

map(modenx, "x", '"_x', opts)
map(modenx, "X", '"_X', opts)

map(modenx, "c", '"_c', opts)
map(modenx, "C", '"_C', opts)

map(modenx, "<C-[>", "<C-u>zz0", opts)
map(modenx, "<C-]>", "<C-d>zz0", opts)

map(modenx, "gl", "gu", opts)
map(modenx, "gu", "gU", opts)
map(moden, "<C-d>", '"ayy"ap', opts)

map(modenx, "<C-c>", "<Esc>", opts)
map(modei, "jj", "<Esc>", opts)

map(moden, "<C-j>", "<cmd>move +1<CR>", opts)
map(moden, "<C-k>", "<cmd>move -2<CR>", opts)

map(modex, "<C-j>", ":move '>+1<CR>gv=gv", opts)
map(modex, "<C-k>", ":move '<-2<CR>gv=gv", opts)

map(modex, ">", ">gv", opts)
map(modex, "<", "<gv", opts)

map(moden, "o", "o<Esc>", opts)
map(moden, "O", "O<Esc>", opts)

-- Move focus to the left window
vim.keymap.set('n', '<S-Left>', '<C-w><C-h>')
-- Move focus to the right window
vim.keymap.set('n', '<S-Right>', '<C-w><C-l>')
-- Move focus to the lower window
vim.keymap.set('n', '<S-Down>', '<C-w><C-j>')
-- Move focus to the lower window
vim.keymap.set('n', '<S-Up>', '<C-w><C-k>')


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

-- - Symbol Search
map("n", "<leader>ds", telescope.lsp_document_symbols, opts)
map("n", "<leader>ws", telescope.lsp_dynamic_workspace_symbols, opts)
map("n", "<leader>ss", telescope.live_grep, opts)

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
map("n", "<C-w>", "<cmd>BufferClose<CR>", opts)

-- =================================

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
