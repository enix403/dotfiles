local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- NOTE: We must pass a table (even if empty) to lspconfig.SERVERNAME.setup(...)

local capabilities = cmp_nvim_lsp.default_capabilities()

local function mapkeys(_client, bufnr)

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
  on_attach = mapkeys,
  on_init = function(client)
    --[[ local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
      return
    end ]]

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
  on_attach = mapkeys
})


-- lspconfig["pylsp"].setup({
--   capabilities = capabilities,
--   on_attach = mapkeys,
--
--   settings = {
--     pylsp = {
--       plugins = {
--         pyflakes = {
--           enabled = true,
--           ignore = {"undefined-variable"}  -- Ignore undefined variable warnings
--         },
--         pycodestyle = {
--           ignore = {
--             'E501',
--             'E302',
--             'E305',
--             'W293',
--             'W391',
--             'W401',
--             'E303',
--           },
--         }
--       }
--     }
--   }
-- })


require("typescript-tools").setup({
  capabilities = capabilities,
  on_attach = mapkeys,
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
    mapkeys(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = { "*.js", "*.ts" },
      callback = function(ctx)
        client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
      end,
    })
  end
})

lspconfig["rust_analyzer"].setup({
  capabilities = capabilities,
  on_attach = mapkeys
})

lspconfig['jdtls'].setup({
  on_attach = mapkeys,
  capabilities = capabilities,
  cmd = {
    "/home/radium/Applications/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/bin/jdtls",

    -- "-jar /home/radium/Applications/apache-tomcat-10.1.28/lib/servlet-api.jar",
    -- "-jar /home/radium/Applications/apache-tomcat-10.1.28/lib/jsp-api.jar",
    -- "-cp /home/radium/Applications/apache-tomcat-10.1.28/lib/servlet-api.jar:/home/radium/Applications/apache-tomcat-10.1.28/lib/jsp-api.jar",
    "-cp .:/home/radium/Applications/apache-tomcat-10.1.28/lib/*",

    "-configuration",
    "/home/radium/.cache/jdtls/config",
    "-data",
    "/home/radium/.cache/jdtls/workspace",
  }
})

--[[ local jdtls = require('jdtls')
-- Java Language Server configuration
local function setup_jdtls()
  -- Get the jdtls plugin path

  -- Define your workspace directory
  local workspace_dir = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

  -- Set up the language server configuration
  local config = {
    cmd = { 'java-lsp.sh', workspace_dir },
    root_dir = jdtls.setup.find_root({ '.git', 'mvnw', 'gradlew' }),
    -- Add any other custom config options here
    settings = {
      java = {
        -- Additional settings
      },
    },
    init_options = {
      bundles = {}
    },
  }

  -- Start or attach to the LSP client
  jdtls.start_or_attach(config)
end

-- Autocommand for setting up jdtls for Java files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'java',
  callback = setup_jdtls
}) ]]
