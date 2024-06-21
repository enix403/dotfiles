local lspconfig = require("lspconfig")

-- NOTE: We must pass a table (even if empty) to lspconfig.SERVERNAME.setup(...)

lspconfig['lua_ls'].setup({
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
--   on_attach = on_attach,
--   on_init = function(client)
--     local path = client.workspace_folders[1].name
--     if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
--       return
--     end
-- 
--     client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
--       runtime = {
--         -- Tell the language server which version of Lua you're using
--         -- (most likely LuaJIT in the case of Neovim)
--         version = 'LuaJIT'
--       },
--       -- Make the server aware of Neovim runtime files
--       workspace = {
--         checkThirdParty = false,
--         library = {
--           vim.env.VIMRUNTIME
--           -- Depending on the usage, you might want to add additional paths here.
--           -- "${3rd}/luv/library"
--           -- "${3rd}/busted/library",
--         }
--         -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
--         -- library = vim.api.nvim_get_runtime_file("", true)
--       }
--     })
--   end,
--   settings = {
--     Lua = {
--       -- diagnostics = {
--       --   globals = { "vim" }
--       -- },
--       -- completion = {
--       --   callSnippet = "Replace"
--       -- }
--     }
--   }
-- })
