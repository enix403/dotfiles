local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local typescript = require("typescript")

local on_attach = function(client, bufnr)
  print("Attached: " .. client.name .. " on buf: " .. bufnr)
end

local capabilities = cmp_nvim_lsp.default_capabilities()

lspconfig.html.setup({ capabilities = capabilities, on_attach = on_attach })
lspconfig.tsserver.setup({ capabilities = capabilities, on_attach = on_attach })
lspconfig.cssls.setup({ capabilities = capabilities, on_attach = on_attach })
lspconfig.tailwindcss.setup({ capabilities = capabilities, on_attach = on_attach })
lspconfig.lua_ls.setup({ capabilities = capabilities, on_attach = on_attach })

