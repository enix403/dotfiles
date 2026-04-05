local map = vim.keymap.set

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
map("i", "<A-BS>", ctrl_bs_delete_prev_word, {
  silent = true,
  desc = "Ctrl-Backspace: delete previous word (undo-friendly)",
})
