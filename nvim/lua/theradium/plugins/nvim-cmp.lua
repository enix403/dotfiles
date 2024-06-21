local cmp = require("cmp")

cmp.setup({
  sources = cmp.config.sources({
    { name = "nvim_lsp" }
  })
})

-- local cmp = require("cmp")
-- local snip = require("luasnip")
-- 
-- require("luasnip.loaders.from_vscode").lazy_load()
-- vim.opt.completeopt = "menu,menuone,noselect"
-- 
-- cmp.setup({
--   snippet = {
--     expand = function(args)
--       snip.lsp_expand(args.body)
--     end
--   },
--   mapping = cmp.mapping.preset.insert({
--     ['<C-k>'] = cmp.mapping.select_prev_item(),
--     ['<C-j>'] = cmp.mapping.select_next_item(),
--     ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--     ['<C-f>'] = cmp.mapping.scroll_docs(4),
--     ['<C-Space>'] = cmp.mapping.complete(),
--     ['<C-e>'] = cmp.mapping.abort(),
--     ['<CR>'] = cmp.mapping.confirm({ select = true }),
--   }),
-- 
--   sources = cmp.config.sources({
--     { name = "nvim_lsp" },
--     { name = "luasnip" },
--     { name = "buffer" },
--     { name = "path" },
--   })
-- })
