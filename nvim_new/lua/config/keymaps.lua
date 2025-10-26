-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- TODO: categorize in two: Fixing existing shortcuts vs adding new

-- TODO: These are captured by kitty for window resizing
-- Do something about it
-- map("n", "<S-Up>", ":resize -2<CR>")
-- map("n", "<S-Down>", ":resize +2<CR>")
-- map("n", "<S-Left>", ":vertical resize -2<CR>")
-- map("n", "<S-Right>", ":vertical resize +2<CR>")

-- TODO: explore
-- Map("n", "<TAB>", ":bn<CR>")
-- Map("n", "<S-TAB>", ":bp<CR>")

-- NOTE: It appears it is no longer needed. Explore
-- add an "actual" indent (with spaces/tabs) instead of just
-- putting a cursor there (and thus unindenting the line when the
-- moves away)
-- map("i", "<CR>", "<CR> <BS>")

-- BUILT INTO LAZY VIM
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
-- vim.api.nvim_create_autocmd('TextYankPost', {
--   desc = 'Highlight when yanking (copying) text',
--   group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
--   callback = function()
--     vim.highlight.on_yank()
--   end,
-- })

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

-- Make x and c operations not modify clipboards
map({ "n", "x" }, "x", '"_x')
map({ "n", "x" }, "X", '"_X')
map({ "n", "x" }, "c", '"_c')
map({ "n", "x" }, "C", '"_C')

-- I dont want fancy combinations with > and <
-- Just want to use them to indent/deindent
map("n", "<", "<<")
map("n", ">", ">>")

-- Make > and < work in visual mode as well
map("x", ">", ">gv")
map("x", "<", "<gv")

-- Make o/O come back to normal mode after creating a
-- blank line below/above
map("n", "o", "o <BS><Esc>")
map("n", "O", "O <BS><Esc>")

-- Scroll up/down half a page and put the cursor in
-- the middle
--
-- <C-u>/<C-d>: move half page up/down
-- zz: Recenter so that the line of the cursor is in the middle
-- 0: move the cursor to the start of the line
map({ "n", "x" }, "{", "<C-u>zz0")
map({ "n", "x" }, "}", "<C-d>zz0")

-- In visual mode if you select something and press p, it will paste
-- whatever was in the register, overrwitting the selected text. This
-- is okay, but the overritten text is now placed in that register.
-- This basically limits you to be able to paste only once.
--
-- This keymap makes is so that the register is preserved when pasting
-- over some selected text in visual mode
map("x", "p", function()
  -- Get the current active register...
  local register = vim.v.register
  -- and its contents
  local contents = vim.fn.getreg(register)
  -- do a regular paste
  vim.cmd("normal! p")
  -- and restore the contents of the active register
  vim.fn.setreg(register, contents)
end)

-- Move the selected lines up and down, but also, keep those lines
-- selected
--
-- These work, but throw an error when the lines are already at the
-- bounds of the file (at the start or the top). This needs to be fixed
map("x", ",", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })
map("x", ".", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })

-- Select all text in file using Ctrl+A
map("n", "<C-a>", "ggVG", { desc = "Select all text" })

-- Duplicate line (or selection) down
map("n", "<C-d>", '"ayy"ap', { desc = "Duplicate line down" })
map("x", "<C-d>", ":'<,'>t'><CR>gv", { desc = "Duplicate selection down" })

-- Exit terminal mode using Esc
--
-- Not needed in neovim, since apparently pressing Esc twice really fast
-- seems to get out of terminal mode
-- map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode to normal mode" })
