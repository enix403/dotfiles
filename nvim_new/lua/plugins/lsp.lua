return {
  -- Will try to enable every installed server
  { "mason-org/mason-lspconfig.nvim", enabled = false },
  {
    "neovim/nvim-lspconfig",
      ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- Installed via Mason
        clangd = { },

        -- Installed manually outside of neovim
        basedpyright = { mason = false }
      },
    },
  }
}