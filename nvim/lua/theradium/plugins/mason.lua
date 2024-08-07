-- Call mason.setup(..,) first
require("mason").setup({
  log_level = vim.log.levels.DEBUG
})

-- Setup Language Servers
require("mason-lspconfig").setup({
  ensure_installed = {
    "tsserver",
    "svelte",
    "cssls",
    "tailwindcss",

    "clangd",
    "rust_analyzer",
    "pyright",

    "lua_ls"
  }
})
