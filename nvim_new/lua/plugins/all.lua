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

  --[[ Disable ]]
}

