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

local function mydel_is_word_char(ch)
  return ch:match("^[0-9A-Za-z_]$") ~= nil
end

local function mydel_is_single_space(ch)
  return ch == " "
end

local function mydel_char_at(s, ci) -- ci: 0-based UTF-8 character index
  local b0 = vim.str_byteindex(s, ci)
  local b1 = vim.str_byteindex(s, ci + 1)
  return s:sub(b0 + 1, b1)
end

local function mydel_feed(keys)
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
    if not mydel_is_single_space(mydel_char_at(left, k)) then
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
    if k >= 0 and mydel_is_word_char(mydel_char_at(left, k)) then
      -- Delete that one space + the preceding word
      while k >= 0 and mydel_is_word_char(mydel_char_at(left, k)) do
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
    if mydel_is_word_char(mydel_char_at(left, k)) then
      -- In or at end of a word -> delete back to word start
      while k >= 0 and mydel_is_word_char(mydel_char_at(left, k)) do
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
  mydel_feed("<C-g>u" .. string.rep("<BS>", delete_chars))
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
-- used for lsp goto def unwinding
-- Make ctrl-i go backwards
-- Make ctrl-o go forwards
-- TODO: Explain in comments
map("n", "<C-i>", "<C-o>")
map("n", "<C-o>", "<C-i>")

-------------

-- Custom "w": move to END of the next token (or current one), in n/x modes.
-- Token rules:
--   * word = [A-Za-z0-9_]+
--   * symbol group = one or more consecutive non-whitespace, non-word chars
--   * whitespace (space/tab) is skipped
-- Cross-line: if no more tokens on the current line, go to the first non-whitespace
-- token on the next line and land on its end.
--
-- Structured so we can add a backward 'b' later by reusing helpers.

local function is_word_char(ch)
  return ch:match("^[0-9A-Za-z_]$") ~= nil
end

local function is_space_char(ch)
  return ch == " " or ch == "\t"
end

local function char_count(s)
  return vim.str_utfindex(s)
end

local function char_at(s, ci) -- ci: 0-based char index
  local b0 = vim.str_byteindex(s, ci)
  local b1 = vim.str_byteindex(s, ci + 1)
  return s:sub(b0 + 1, b1)
end

local function classify_char(ch)
  if ch == nil or ch == "" then
    return "eol"
  end
  if is_space_char(ch) then
    return "ws"
  end
  if is_word_char(ch) then
    return "word"
  end
  return "sym"
end

local function find_run_end_in_line(line, ci_start, kind)
  local n = char_count(line)
  local ci = ci_start
  while ci + 1 < n do
    local ch = char_at(line, ci + 1)
    local k = classify_char(ch)
    if k ~= kind then
      break
    end
    ci = ci + 1
  end
  return ci -- inclusive
end

local function next_non_ws_in_line(line, from_ci)
  local n = char_count(line)
  local ci = math.max(0, from_ci)
  while ci < n do
    local ch = char_at(line, ci)
    if classify_char(ch) ~= "ws" then
      return ci
    end
    ci = ci + 1
  end
  return nil
end

-- Find the end-of-token destination for one forward step
local function next_token_end_forward(row0, col0)
  local row = row0
  local col = col0
  local buf = 0
  local last_row = vim.api.nvim_buf_line_count(buf) - 1

  -- Current line data
  local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, true)[1] or ""
  local ci = vim.str_utfindex(line, col) -- char index of current cursor
  local n = char_count(line)

  local function goto_first_token_end_next_lines(r)
    r = r + 1
    while r <= last_row do
      local l = vim.api.nvim_buf_get_lines(buf, r, r + 1, true)[1] or ""
      local nn = char_count(l)
      if nn > 0 then
        local start_ci = next_non_ws_in_line(l, 0)
        if start_ci ~= nil then
          local kind = classify_char(char_at(l, start_ci))
          if kind == "ws" then
            -- all ws, try next line
          else
            local end_ci = find_run_end_in_line(l, start_ci, kind)
            return r, vim.str_byteindex(l, end_ci)
          end
        end
      end
      r = r + 1
    end
    return row0, col0 -- nowhere to go, stay
  end

  -- Helper: target end for the next token starting at some char index on the same line
  local function end_of_next_token_same_line(start_ci)
    local k = classify_char(char_at(line, start_ci))
    if k == "ws" then
      local first = next_non_ws_in_line(line, start_ci)
      if first == nil then
        return nil
      end
      k = classify_char(char_at(line, first))
      local end_ci = find_run_end_in_line(line, first, k)
      return end_ci
    else
      -- already on token start/middle/end
      local end_ci = find_run_end_in_line(line, start_ci, k)
      return end_ci
    end
  end

  -- Decide based on char under cursor
  local cur_ch = (ci < n) and char_at(line, ci) or nil
  local kind = classify_char(cur_ch)

  if kind == "word" or kind == "sym" then
    -- End of current run
    local end_ci = find_run_end_in_line(line, ci, kind)
    if end_ci > ci then
      -- We were inside the run -> go to its end
      return row, vim.str_byteindex(line, end_ci)
    else
      -- Already at the end of this run -> go to the end of the next non-ws token
      local next_ci = ci + 1
      local first = next_non_ws_in_line(line, next_ci)
      if first ~= nil then
        local next_kind = classify_char(char_at(line, first))
        local end_ci2 = find_run_end_in_line(line, first, next_kind)
        return row, vim.str_byteindex(line, end_ci2)
      else
        -- No more tokens on this line -> next line
        return goto_first_token_end_next_lines(row)
      end
    end
  elseif kind == "ws" then
    -- Skip ws to the next token and go to its end
    local first = next_non_ws_in_line(line, ci)
    if first ~= nil then
      local k2 = classify_char(char_at(line, first))
      local end_ci = find_run_end_in_line(line, first, k2)
      return row, vim.str_byteindex(line, end_ci)
    else
      -- Only trailing ws -> next line
      return goto_first_token_end_next_lines(row)
    end
  else -- 'eol' (empty line or cursor beyond chars)
    return goto_first_token_end_next_lines(row)
  end
end

function move_w_end_forward()
  local count = vim.v.count1 or 1
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  col = col

  for _ = 1, count do
    local nr, nc = next_token_end_forward(row, col)
    if nr == row and nc == col then
      break
    end
    row, col = nr, nc
  end

  vim.api.nvim_win_set_cursor(0, { row + 1, col })
end

-- Keymaps: w in normal and visual modes
map({ "n", "x" }, "w", move_w_end_forward, {
  silent = true,
  desc = "Move to END of next token (custom w)",
})

-- Custom "b": move to START of the previous token (or current one if inside), in n/x modes.
-- Token rules:
--   * word = [A-Za-z0-9_]+
--   * symbol group = one or more consecutive non-whitespace, non-word chars
--   * whitespace (space/tab) is skipped
-- Cross-line: if nothing left on the current line, go to the start of the last
-- non-whitespace token on the previous non-empty line.

local function find_run_start_in_line(line, ci_start, kind)
  local ci = ci_start
  while ci - 1 >= 0 do
    local ch = char_at(line, ci - 1)
    if classify_char(ch) ~= kind then
      break
    end
    ci = ci - 1
  end
  return ci -- inclusive (first char of the run)
end

local function prev_non_ws_in_line(line, from_ci)
  local ci = math.min(from_ci, math.max(0, char_count(line) - 1))
  while ci >= 0 do
    local ch = char_at(line, ci)
    if classify_char(ch) ~= "ws" then
      return ci
    end
    ci = ci - 1
  end
  return nil
end

-- Find the start-of-token destination for one backward step
local function prev_token_start_backward(row0, col0)
  local buf = 0
  local last_row = vim.api.nvim_buf_line_count(buf) - 1
  local row = row0
  local col = col0

  local function goto_last_token_start_prev_lines(r)
    r = r - 1
    while r >= 0 do
      local line = vim.api.nvim_buf_get_lines(buf, r, r + 1, true)[1] or ""
      local last_non_ws_ci = prev_non_ws_in_line(line, char_count(line) - 1)
      if last_non_ws_ci ~= nil then
        local kind = classify_char(char_at(line, last_non_ws_ci))
        if kind ~= "ws" then
          local start_ci = find_run_start_in_line(line, last_non_ws_ci, kind)
          return r, vim.str_byteindex(line, start_ci)
        end
      end
      r = r - 1
    end
    return row0, col0 -- nowhere to go
  end

  local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, true)[1] or ""
  local ci = vim.str_utfindex(line, col) -- char index at cursor boundary
  local k = ci - 1 -- char immediately to the left of the cursor

  if k < 0 then
    return goto_last_token_start_prev_lines(row)
  end

  local ch = char_at(line, k)
  local kind = classify_char(ch)

  if kind == "ws" then
    -- Skip left over whitespace, then land at the start of that token
    local left_ci = prev_non_ws_in_line(line, k)
    if left_ci == nil then
      return goto_last_token_start_prev_lines(row)
    end
    local kind2 = classify_char(char_at(line, left_ci))
    local start_ci = find_run_start_in_line(line, left_ci, kind2)
    return row, vim.str_byteindex(line, start_ci)
  elseif kind == "word" or kind == "sym" then
    -- We are on a token (by inspecting the char to the left). Go to its start.
    local start_ci = find_run_start_in_line(line, k, kind)
    return row, vim.str_byteindex(line, start_ci)
  else
    -- 'eol' or empty line; go to previous lines
    return goto_last_token_start_prev_lines(row)
  end
end

function move_b_start_backward()
  local count = vim.v.count1 or 1
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  col = col

  for _ = 1, count do
    local nr, nc = prev_token_start_backward(row, col)
    if nr == row and nc == col then
      break
    end
    row, col = nr, nc
  end

  vim.api.nvim_win_set_cursor(0, { row + 1, col })
end

-- Keymaps: b in normal and visual modes
map({ "n", "x" }, "b", move_b_start_backward, {
  silent = true,
  desc = "Move to START of previous token (custom b)",
})
