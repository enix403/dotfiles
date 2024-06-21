local cmp = require("cmp")
local lspkind = require("lspkind")

local function map_if_visible(func)
  return function (fallback)
    if cmp.visible() then
      func()
    else
      fallback()
    end
  end
end

cmp.setup({
  sources = cmp.config.sources({
    { name = "nvim_lsp" }
  }),

  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<Up>'] = map_if_visible(cmp.select_prev_item),
    ['<Down>'] = map_if_visible(cmp.select_next_item),
    -- ['<Tab>'] = map_if_visible(cmp.select_next_item),
    -- ['<S-Tab>'] = map_if_visible(cmp.select_prev_item),
    ['<Esc>'] = map_if_visible(cmp.abort),
    ['<CR>'] = map_if_visible(function() cmp.confirm({ select = true }) end),
    ['<Tab>'] = map_if_visible(function() cmp.confirm({ select = true }) end)
  },


  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text', -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      -- can also be a function to dynamically calculate max width such as 
      -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
      show_labelDetails = true, -- show labelDetails in menu. Disabled by default
    })
  }
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
