-- Call mason.setup(..,) first
require("mason").setup()

-- Setup Language Servers
require("mason-lspconfig").setup({
  ensure_installed = {
    "tsserver",
    "cssls",
    "tailwindcss",

    "clangd",
    "rust_analyzer",
    "pyright",

    "lua_ls"
  }
})
