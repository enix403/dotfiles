-- The active colorscheme is written by `settheme` into the generated (and
-- gitignored) `config.colorscheme` module, so nvim tracks the theme picked for
-- the rest of the terminal. Fresh clones (no generated file) fall back to
-- catppuccin-mocha. Already-running nvim instances need a restart or a manual
-- `:colorscheme <name>` to pick up a change.
local function active_colorscheme()
  local ok, name = pcall(require, "config.colorscheme")
  if ok and type(name) == "string" and name ~= "" then
    return name
  end
  return "catppuccin-mocha"
end

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

  -- Colorscheme plugins for the `settheme` lineup. Lazy-loaded; only the active
  -- one is actually applied. Keep names in sync with the `settheme` registry.
  { "folke/tokyonight.nvim", lazy = true },
  { "ellisonleao/gruvbox.nvim", lazy = true },
  { "rose-pine/neovim", name = "rose-pine", lazy = true },
  { "shaunsingh/nord.nvim", lazy = true },
  { "rebelot/kanagawa.nvim", lazy = true },
  { "Mofiqul/dracula.nvim", lazy = true },
  { "navarasu/onedark.nvim", lazy = true },

  -- {
  --   "xiyaowong/transparent.nvim",
  --   lazy = false,
  --   enabled = false,
  -- },
  { "LazyVim/LazyVim", opts = { colorscheme = active_colorscheme() } },
}
