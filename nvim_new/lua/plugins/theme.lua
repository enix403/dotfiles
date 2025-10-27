return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      -- typicode/bg.nvim handles this transparency as well
      -- as bg color syncing
      -- transparent_background = false,

      -- https://github.com/catppuccin/nvim/discussions/676
      --
      -- The default border color (MOCHA) between splits is barely
      -- visible (at least) on my terminal. This changes it to
      -- match the split border color of my terminal's (kitty)
      -- catpuccin mocha border color
      custom_highlights = function(colors)
        return {
          WinSeparator = { fg = "#B4BEFE" },
        }
      end,
    },
  },
  -- {
  --   "xiyaowong/transparent.nvim",
  --   lazy = false,
  --   enabled = false,
  -- },
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin-mocha" } },
}
