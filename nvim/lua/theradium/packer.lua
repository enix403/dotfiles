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
  -- use("nvim-treesitter/nvim-treesitter-context")

  -- telescope
  use('nvim-telescope/telescope.nvim', { tag = '0.1.6' })

  -- transparent
  use("xiyaowong/transparent.nvim")

  -- themes
  use('arcticicestudio/nord-vim')

  -- status line
  use('nvim-lualine/lualine.nvim')

  use('nvim-tree/nvim-tree.lua')
  use("onsails/lspkind.nvim")

  use("stevearc/dressing.nvim")

  -- tools/lsp/formatting
  use("williamboman/mason.nvim")
  use("neovim/nvim-lspconfig")
  use("williamboman/mason-lspconfig.nvim")

  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-nvim-lsp")

  -- comments
  use("numToStr/Comment.nvim")

  -- auto closing
  use("m4xshen/autoclose.nvim")

  -- top tab line
  use("romgrk/barbar.nvim")

  use("akinsho/toggleterm.nvim", {
    tag = '*',
  })

  -- use("hrsh7th/cmp-buffer")
  -- use("hrsh7th/cmp-path")
  --
  --  use({
  --    "L3MON4D3/LuaSnip",
  --    tag = "v2.*",
  --    run = "make install_jsregexp"
  --  })
  --  use("saadparwaiz1/cmp_luasnip")
  --  use("rafamadriz/friendly-snippets")
  --
  --  use("hrsh7th/cmp-nvim-lsp")
  --  use({ "glepnir/lspsaga.nvim", branch = "main" })
  --  use("jose-elias-alvarez/typescript.nvim")
  --  use("onsails/lspkind.nvim")
end)
