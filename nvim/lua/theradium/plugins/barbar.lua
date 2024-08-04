vim.g.barbar_auto_setup = false

require("barbar").setup({
  animation = false,
  sidebar_filetypes = {
    NvimTree = true,
  }
})
