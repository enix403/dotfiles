local map = vim.keymap.set

-- Disable Snacks.nvim terminal (its keymaps).
-- I don't like it
vim.keymap.del({ "n", "t" }, "<C-/>")
vim.keymap.del({ "n", "t" }, "<C-_>")

-- Exit terminal mode using Esc
--
-- Not needed in lazyvim, since apparently pressing Esc twice really fast
-- seems to get out of terminal mode
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode to normal mode" })

-- Toggle Terminal in current directory
map({ "n", "t" }, "<C-/>", "<cmd>ToggleTerm dir=%:p:h size=25<CR>", { desc = "Toggle Terminal" })
