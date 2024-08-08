local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- NOTE: We must pass a table (even if empty) to lspconfig.SERVERNAME.setup(...)

local capabilities = cmp_nvim_lsp.default_capabilities()

local function on_attach(_client, bufnr)

  local keymap = function(mode, keys, cmd, desc, remap)
    if remap == nil then
      remap = false
    end
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set(mode, keys, cmd, { desc = desc, remap = remap, buffer = bufnr })
  end

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  local telescope = require('telescope.builtin')

  keymap("n", "gd", vim.lsp.buf.definition, "Goto Definition")
  keymap("n", "<M-S-Right>", vim.lsp.buf.definition, "Goto Definition")

  keymap("n", "gh", vim.lsp.buf.hover, "Hover Symbol")
  keymap("n", "gt", telescope.lsp_type_definitions)

  keymap("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
  
  keymap("n", "<leader>ca", vim.lsp.buf.code_action, "Code Actions")
  keymap("n", "<C-.>", vim.lsp.buf.code_action, "Code Actions")


end

lspconfig['lua_ls'].setup({
  capabilities = capabilities,
  on_attach = on_attach,
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
  capabilities = capabilities,
  on_attach = on_attach
})

require("typescript-tools").setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    expose_as_code_action = "all",
    jsx_close_tag = {
      enable = false,
      filetypes = { "javascriptreact", "typescriptreact" },
    }
  }
})

-- https://www.reddit.com/r/neovim/comments/1598ewp/comment/jtduy0x
lspconfig["svelte"].setup({
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = { "*.js", "*.ts" },
      callback = function(ctx)
        client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
      end,
    })
  end
})

lspconfig['jdtls'].setup({
  on_attach = on_attach,
  cmd = {
    "/home/radium/Applications/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/bin/jdtls",

    "-configuration",
    "/home/radium/.cache/jdtls/config",
    "-data",
    "/home/radium/.cache/jdtls/workspace"
  }
})
