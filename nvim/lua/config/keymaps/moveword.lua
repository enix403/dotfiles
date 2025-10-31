local map = vim.keymap.set

-- Custom "w": move to END of the next token (or current one), in n/x modes.
-- Token rules:
--   * word = [A-Za-z0-9_]+
--   * symbol group = one or more consecutive non-whitespace, non-word chars
--   * whitespace (space/tab) is skipped
-- Cross-line: if no more tokens on the current line, go to the first non-whitespace
-- token on the next line and land on its end.
--
-- Structured so we can add a backward 'b' later by reusing helpers.

-- ---------------------
-- Common

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

-- ---------------------

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
