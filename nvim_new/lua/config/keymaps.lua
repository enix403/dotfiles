-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- TODO: These are captured by kitty for window resizing
-- Do something about it
-- map("n", "<S-Up>", ":resize -2<CR>")
-- map("n", "<S-Down>", ":resize +2<CR>")
-- map("n", "<S-Left>", ":vertical resize -2<CR>")
-- map("n", "<S-Right>", ":vertical resize +2<CR>")

-- TODO: explore
-- Map("n", "<TAB>", ":bn<CR>")
-- Map("n", "<S-TAB>", ":bp<CR>")

local map = vim.keymap.set

-- Navigate windows using Shift+hjkl
map("n", "<S-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<S-j>", "<C-w>j", { desc = "Move to window below" })
map("n", "<S-k>", "<C-w>k", { desc = "Move to window above" })
map("n", "<S-l>", "<C-w>l", { desc = "Move to right window" })

-- Resize window using Ctrl+Shift+hjkl
map("n", "<C-S-h>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-S-l>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })
map("n", "<C-S-j>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-S-k>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })

-- Make x and c operations not modify clipboards
map({ "n", "x" }, "x", '"_x', opts)
map({ "n", "x" }, "X", '"_X', opts)
map({ "n", "x" }, "c", '"_c', opts)
map({ "n", "x" }, "C", '"_C', opts)

-- I dont want fancy combinations with > and <
-- Just want to use them to indent/deindent
map("n", "<", "<<", opts)
map("n", ">", ">>", opts)

-- Make o come back to normal mode
map("n", "o", "o <BS><Esc>", opts)
map("n", "O", "O <BS><Esc>", opts)
