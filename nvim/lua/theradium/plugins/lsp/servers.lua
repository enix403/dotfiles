local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- NOTE: We must pass a table (even if empty) to lspconfig.SERVERNAME.setup(...)o

local capabilities = cmp_nvim_lsp.default_capabilities() 

function on_attach(client, bufnr)

  local keymap = function(mode, keys, cmd, desc)
  end

end

lspconfig['lua_ls'].setup({
  capabilities = capabilities,
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
      return
    end

    local settings = client.config.settings or {}
    client.config.settings = settings

    settings.Lua = vim.tbl_deep_extend('force', settings.Lua or {}, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT'
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
        }
      }
    })
  end,
})

lspconfig["pyright"].setup({
  capabilities = capabilities
})

-- local lspconfig = require("lspconfig")
-- local cmp_nvim_lsp = require("cmp_nvim_lsp")
-- local typescript = require("typescript")
-- 
-- local on_attach = function(client, bufnr)
--   print("Attached: " .. client.name .. " on buf: " .. bufnr)
-- end
-- 
-- local capabilities = cmp_nvim_lsp.default_capabilities()
-- 
-- lspconfig.html.setup({ capabilities = capabilities, on_attach = on_attach })
-- typescript.setup({ capabilities = capabilities, on_attach = on_attach })
-- lspconfig.cssls.setup({ capabilities = capabilities, on_attach = on_attach })
-- lspconfig.tailwindcss.setup({ capabilities = capabilities, on_attach = on_attach })
-- lspconfig.lua_ls.setup({
--   capabilities = capabilities,
-- })
