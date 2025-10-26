--[[
disable spell check
]]

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
  { "folke/noice.nvim", opts = {
    cmdline = {
      view = "cmdline",
    },
  } },

  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        ghost_text = {
          enabled = false,
        },
      },
      -- https://github.com/Saghen/blink.cmp/discussions/564#discussioncomment-11905466
      sources = {
        default = function()
          local node = vim.treesitter.get_node()
          if
            node and vim.tbl_contains({
              "comment", "line_comment", "comment_content", "block_comment",
              "string_start", "string_content", "string_end"
            }, node:type())
          then
            return { }
          else
            return {  "lsp", "path", "snippets", "buffer"  }
          end
        end,
      },
    },
    opts_extend = { "sources.default" },
  },

  --[[ Disable ]]
}
