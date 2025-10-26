return {
  -- Will try to enable every installed server. Need to disable it
  { "mason-org/mason-lspconfig.nvim", enabled = false },
  -- Configs
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        -- Adding a key value pair here (e.g `clangd = {}`) will
        -- "enable" the server i.e have it automatically start
        -- when entering a relevant buffer.
        -- It will also try to install the server via mason if
        -- not installed

        -- Installed via Mason
        clangd = {},

        -- Installed manually outside of neovim
        basedpyright = { mason = false },
      },
    },
  },
}

