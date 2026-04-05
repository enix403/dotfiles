local map = vim.keymap.set

-- Tab navigation using Tab and Shift+Tab
map("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer/tab" })
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer/tab" })