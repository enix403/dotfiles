-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("theradium.packer")

require("theradium.core.options")
require("theradium.core.keymaps")
require("theradium.core.colorscheme")

require("theradium.plugins.transparent")
require("theradium.plugins.treesitter")
require("theradium.plugins.nvim-tree")
require("theradium.plugins.lualine")
require("theradium.plugins.nvim-cmp")
