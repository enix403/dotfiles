-- Disable blink.cmp completions in comments
-- https://github.com/Saghen/blink.cmp/discussions/564#discussioncomment-13439030
local in_treesitter_capture = function(capture)
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  if vim.api.nvim_get_mode().mode == "i" then
    col = col - 1
  end

  local buf = vim.api.nvim_get_current_buf()
  local get_captures_at_pos = require("vim.treesitter").get_captures_at_pos

  local captures_at_cursor = vim.tbl_map(function(x)
    return x.capture
  end, get_captures_at_pos(buf, row - 1, col))

  if vim.tbl_isempty(captures_at_cursor) then
    return false
  elseif type(capture) == "string" and vim.tbl_contains(captures_at_cursor, capture) then
    return true
  elseif type(capture) == "table" then
    for _, v in ipairs(capture) do
      if vim.tbl_contains(captures_at_cursor, v) then
        return true
      end
    end
  end
  return false
end

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  },
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin-mocha" } },

  -- Move the floating cmdline back to bottom
  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        view = "cmdline",
      },
    }
},

  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        ghost_text = {
          enabled = false,
        },
        menu = {
          auto_show = function()
            return not in_treesitter_capture("comment")
          end,
        },
      },
    },
    opts_extend = { "sources.default" },
  },

  --[[ Disable ]]
}
