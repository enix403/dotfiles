local map = vim.keymap.set

-- Using https://github.com/knubie/vim-kitty-navigator to integrate
-- vim and kitty splits using the same shortcut key
--
-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<cmd>KittyNavigateLeft<CR>", { desc = "Go to Left Window" })
map("n", "<C-j>", "<cmd>KittyNavigateDown<CR>", { desc = "Go to Lower Window" })
map("n", "<C-k>", "<cmd>KittyNavigateUp<CR>", { desc = "Go to Upper Window" })
map("n", "<C-l>", "<cmd>KittyNavigateRight<CR>", { desc = "Go to Right Window" })

-- Resize window using Ctrl+Shift+hjkl
map("n", "<C-S-h>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-S-l>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })
map("n", "<C-S-j>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-S-k>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })