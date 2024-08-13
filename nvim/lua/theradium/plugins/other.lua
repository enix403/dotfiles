require('treesj').setup()

require('config-local').setup({
  -- Config file patterns to load (lua supported)
  config_files = { ".nvim.lua" },

  -- Where the plugin keeps files data
  hashfile = vim.fn.stdpath("data") .. "/config-local",

  autocommands_create = true, -- Create autocommands (VimEnter, DirectoryChanged)
  commands_create = true,     -- Create commands (ConfigLocalSource, ConfigLocalEdit, ConfigLocalTrust, ConfigLocalIgnore)
  silent = false,             -- Disable plugin messages (Config loaded/ignored)
  lookup_parents = true,     -- Lookup config files in parent directories
})

require("nvim-surround").setup({})

require('nvim-ts-autotag').setup({
  opts = {
    -- Defaults
    enable_close = true, -- Auto close tags
    enable_rename = true, -- Auto rename pairs of tags
    enable_close_on_slash = false -- Auto close on trailing </
  }
})

require('dashboard').setup ({
  theme = 'hyper', --  theme is doom and hyper default is hyper
})


