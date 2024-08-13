require("ibl").setup({
  indent = {
    char = "▏"
  },
  scope = {
    enabled = false,
  },
  exclude = {
    filetypes = {
      "dashboard",
      "lspinfo",
      "packer",
      "checkhealth",
      "help",
      "man",
      "gitcommit",
      "TelescopePrompt",
      "TelescopeResults",
    }
  }
})
