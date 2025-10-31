local map = vim.keymap.set

-- Exit terminal mode using Esc
--
-- Not needed in lazyvim, since apparently pressing Esc twice really fast
-- seems to get out of terminal mode
-- map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode to normal mode" })
