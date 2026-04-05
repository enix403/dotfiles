local map = vim.keymap.set

-- Make x/c/d operations not modify clipboard
map({ "n", "x" }, "x", '"_x')
map({ "n", "x" }, "X", '"_X')
map({ "n", "x" }, "c", '"_c')
map({ "n", "x" }, "C", '"_C')
map({ "n", "x" }, "d", '"_d')
map({ "n", "x" }, "D", '"_D')
-- Sometimes, I do need to cut the text, so use <leader>d in those cases
map({ "n", "x" }, "<leader>d", '"+d', { desc = "Cut to system clipboard" })
map("n", "<leader>D", '"+d$', { desc = "Cut to system clipboard to end of line" })

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

-- Swap ctrl i/o
-- used for lsp goto def unwinding
-- Make ctrl-i go backwards
-- Make ctrl-o go forwards
-- TODO: Explain in comments
map("n", "<C-i>", "<C-o>")
map("n", "<C-o>", "<C-i>")
