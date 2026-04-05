local map = vim.keymap.set

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
map({ "n", "x" }, "}", make_move(1), {
  silent = true,
  desc = "Move down by JUMP_UNIT lines, recenter only if scrolled, go to column 0",
})

-- { → move up by JUMP_UNIT (times any count), start-of-line, recenter if scrolled
map({ "n", "x" }, "{", make_move(-1), {
  silent = true,
  desc = "Move up by JUMP_UNIT lines, recenter only if scrolled, go to column 0",
})