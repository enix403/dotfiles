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
-- map({ "n", "x" }, "{", "10kzz0")
-- map({ "n", "x" }, "}", "10jzz0")

-- Adjustable "block" size (change this once to affect both keys)
local JUMP_UNIT = 8

-- Factory that returns a mover for down (+1) or up (-1)
local function make_move(direction)
  return function()
    local count = vim.v.count1 or 1
    local steps = count * JUMP_UNIT * direction

    local view_before = vim.fn.winsaveview()
    local cur = vim.api.nvim_win_get_cursor(0) -- {row (1-based), col (0-based)}
    local last = vim.api.nvim_buf_line_count(0)

    local target_row = cur[1] + steps
    if target_row < 1 then
      target_row = 1
    end
    if target_row > last then
      target_row = last
    end

    -- Move and place at start of line (column 0, like 0)
    vim.api.nvim_win_set_cursor(0, { target_row, 0 })

    -- Recenter only if the window scrolled
    local view_after = vim.fn.winsaveview()
    if view_after.topline ~= view_before.topline or view_after.leftcol ~= view_before.leftcol then
      vim.cmd("normal! zz")
    end
  end
end

-- } → move down by JUMP_UNIT (times any count), start-of-line, recenter if scrolled
vim.keymap.set({ "n", "x" }, "}", make_move(1), {
  silent = true,
  desc = "Move down by JUMP_UNIT lines, recenter only if scrolled, go to column 0",
})

-- { → move up by JUMP_UNIT (times any count), start-of-line, recenter if scrolled
vim.keymap.set({ "n", "x" }, "{", make_move(-1), {
  silent = true,
  desc = "Move up by JUMP_UNIT lines, recenter only if scrolled, go to column 0",
})

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
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode to normal mode" })

-- Delete the previous "word" as defined by [0-9A-Za-z_]
--
-- *Behaviors*:
--   Delete word, keep the single space
--     "some text|" -> "some |"
--
--   Delete back to start of word
--     "some tex|t" -> "some |t"
--
--   Delete the word plus that one space in
--   case of single space after word
--     "some text |" -> "some |"
--
--   Delete all spaces, but not the word, when more than
--   one spaces are present after the word
--     "some text   | -> "some text|"
--
--   Correctly handle single letter words
--     "this is a|" -> "this is |"
--
-- Preserves registers (edits buffer directly). Stays in insert mode.
-- Undo: a single 'u' restores the deletion.

local function is_word_char(ch)
  return ch:match("^[0-9A-Za-z_]$") ~= nil
end

local function is_single_space(ch)
  return ch == " "
end

local function char_at(s, ci) -- ci: 0-based UTF-8 character index
  local b0 = vim.str_byteindex(s, ci)
  local b1 = vim.str_byteindex(s, ci + 1)
  return s:sub(b0 + 1, b1)
end

local function feed(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", true)
end

local function ctrl_bs_delete_prev_word()
  local pos = vim.api.nvim_win_get_cursor(0) -- {line(1-based), col(0-based bytes)}
  local col = pos[2]
  if col == 0 then
    return
  end

  local line = vim.api.nvim_get_current_line()
  local left = line:sub(1, col)

  local ci = vim.str_utfindex(left) -- cursor char index at right edge of 'left'
  local k = ci - 1 -- char index immediately to the left

  -- Count contiguous spaces to the left (spaces only, per your examples)
  local ws_run = 0
  while k >= 0 do
    if not is_single_space(char_at(left, k)) then
      break
    end
    ws_run = ws_run + 1
    k = k - 1
  end

  local start_char
  if ws_run >= 2 then
    -- Multiple spaces -> delete only those spaces
    start_char = ci - ws_run
  elseif ws_run == 1 then
    -- Exactly one space
    if k >= 0 and is_word_char(char_at(left, k)) then
      -- Delete that one space + the preceding word
      while k >= 0 and is_word_char(char_at(left, k)) do
        k = k - 1
      end
      start_char = k + 1
    else
      -- Delete the single space only
      start_char = ci - 1
    end
  else
    -- No space immediately to the left
    if k < 0 then
      return
    end
    if is_word_char(char_at(left, k)) then
      -- In or at end of a word -> delete back to word start
      while k >= 0 and is_word_char(char_at(left, k)) do
        k = k - 1
      end
      start_char = k + 1
    else
      -- Non-word char -> delete just that one char
      start_char = ci - 1
    end
  end

  local delete_chars = ci - start_char
  if delete_chars <= 0 then
    return
  end

  -- Make this deletion its own undo step, then backspace N characters
  feed("<C-g>u" .. string.rep("<BS>", delete_chars))
end

-- Due to some macos problems, my terminal kitty (and thus vim) is forced to receive the Ctrl+Backspace keystroke
-- as Alt-Backspace. Thus in vim, I have to bind this function to <A-BS>
vim.keymap.set("i", "<A-BS>", ctrl_bs_delete_prev_word, {
  silent = true,
  desc = "Ctrl-Backspace: delete previous word (undo-friendly)",
})

---------------

-- Tab navigation using Tab and Shift+Tab
map("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer/tab" })
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer/tab" })

---------------

-- Swap ctrl i/o
-- TODO: Explain in comments
map("n", "<C-i>", "<C-o>")
map("n", "<C-o>", "<C-i>")
