-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use('wbthomason/packer.nvim')

  -- common dependencies
  use('nvim-lua/plenary.nvim')
  use('nvim-tree/nvim-web-devicons')

  -- treesitter
  use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
  use('nvim-treesitter/playground')
  use("Wansmer/treesj")
  
  -- use("nvim-treesitter/nvim-treesitter-context")

  -- telescope
  use('nvim-telescope/telescope.nvim', { tag = '0.1.6' })
  use("ibhagwan/fzf-lua")

  -- transparent
  use("xiyaowong/transparent.nvim")

  -- themes
  use("rebelot/kanagawa.nvim")

  -- status line
  use('nvim-lualine/lualine.nvim')
  
  -- indent guides
  use("lukas-reineke/indent-blankline.nvim")

  use('nvim-tree/nvim-tree.lua')
  use("onsails/lspkind.nvim")

  use("stevearc/dressing.nvim")

  -- tools/lsp/formatting
  use("williamboman/mason.nvim")
  use("neovim/nvim-lspconfig")
  use("williamboman/mason-lspconfig.nvim")

  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-buffer")

  use {
    "pmizio/typescript-tools.nvim",
    requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  }

  -- comments
  use("numToStr/Comment.nvim")
  use("JoosepAlviste/nvim-ts-context-commentstring")

  -- auto closing
  use("m4xshen/autoclose.nvim")

  -- top tab line
  use("romgrk/barbar.nvim")

  -- terminal
  use("akinsho/toggleterm.nvim", {
    tag = '*',
  })

  -- scrollbar
  use("dstein64/nvim-scrollview")

  --
  --  use({
  --    "L3MON4D3/LuaSnip",
  --    tag = "v2.*",
  --    run = "make install_jsregexp"
  --  })
  --  use("saadparwaiz1/cmp_luasnip")
  --  use("rafamadriz/friendly-snippets")
  --
  --  use({ "glepnir/lspsaga.nvim", branch = "main" })
end)
