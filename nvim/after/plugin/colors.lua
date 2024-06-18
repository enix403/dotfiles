
local nvim_transparent = require('transparent')

nvim_transparent.setup({ -- Optional, you don't have to run setup.
    groups = { -- table: default groups
        'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
        'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
        'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
        'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
        'EndOfBuffer',
    },
    extra_groups = { "NormalFloat" }, -- table: additional groups that should be cleared
    exclude_groups = {}, -- table: groups you don't want to clear
})

-- function ColorMyPencils(color)
-- 	color = color or "nord"
-- 	vim.cmd.colorscheme(color)
-- 	-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- 	-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
-- 	-- vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
-- 	-- vim.api.nvim_set_hl(0, "NormalSB", { bg = "none" })
-- end
-- 
-- 
-- ColorMyPencils("lunaperche")
-- ColorMyPencils("rose-pine-moon")
-- ColorMyPencils("nord")

vim.cmd.colorscheme("nord")


