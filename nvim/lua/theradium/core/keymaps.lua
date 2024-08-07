local opts = { remap = false, silent = true }
local map = vim.keymap.set

local moden = "n"
local modei = "i"
local modex = "x"
local modenx = { "n", "x" }
local modexi = { "x", "i" }
local modenxi = { "n", "x", "i" }

vim.g.mapleader = " "

-- disable bad habits
-- map(modenxi, "<C-Left>", "<Nop>", opts)
-- map(modenxi, "<C-Right>", "<Nop>", opts)
-- map(modexi, "<S-Left>", "<Nop>", opts)
-- map(modexi, "<S-Right>", "<Nop>", opts)

-- nevermind I give up
map(modenx, "<C-Left>", "b", opts)
map(modenx, "<C-Right>", "w", opts)

map(modei, "<C-Left>", "<Esc>bi", opts)
map(modei, "<C-Right>", "<Esc>lwi", opts)

-- diable C-* keys arounc C-c
map(modei, "<C-s>", "", opts)
map(modei, "<C-x>", "", opts)
map(modei, "<C-v>", "", opts)
map(modei, "<C-g>", "", opts)

-- select all
map(modenxi, "<C-a>", "<Esc>gg0vG$", opts)

map(modenx, "x", '"_x', opts)
map(modenx, "X", '"_X', opts)

map(modenx, "c", '"_c', opts)
map(modenx, "C", '"_C', opts)

map(modei, "<C-BS>", "<Esc>vbc", opts)

map(modenx, "{", "<C-u>zz0", opts)
map(modenx, "}", "<C-d>zz0", opts)

map(modenx, "gl", "gu", opts)
map(modenx, "gu", "gU", opts)
map(moden, "<C-d>", '"ayy"ap', opts)

map(modenxi, "<C-c>", "<Esc>", opts)

map(moden, "<C-j>", "<cmd>move +1<CR>", opts)
map(moden, "<C-k>", "<cmd>move -2<CR>", opts)

map(modex, "<C-j>", ":move '>+1<CR>gv=gv", opts)
map(modex, "<C-k>", ":move '<-2<CR>gv=gv", opts)

map(modex, ">", ">gv", opts)
map(modex, "<", "<gv", opts)

map(moden, "<", "<<", opts)
map(moden, ">", ">>", opts)

map(modex, 'p', function()
  -- Get the current active register...
  local register = vim.v.register
  -- and its contents
  local contents = vim.fn.getreg(register)
  -- do a regular paste
  vim.cmd("normal! p")
  -- and restore the contents of the active register
  vim.fn.setreg(register, contents)
end, opts)

-- add an "actual" indent (with spaces/tabs) instead of just
-- putting a cursor there (and thus unindenting the line when the
-- moves away)
map(modei, "<CR>", "<CR> <BS>", opts)
map(moden, "o", "o <BS><Esc>", opts)
map(moden, "O", "O <BS><Esc>", opts)

map(moden, "<C-CR>", "o <BS><Esc>", opts)
map(moden, "<CR>", "o <BS><Esc>", opts)

map(moden, "<Esc>", "<Nop>", opts)

map(moden, "<BS>", function()
  local current_line = vim.api.nvim_get_current_line()
  local is_whitespace = current_line:match("^%s*$") ~= nil
  if is_whitespace then
    return '"_ddk$' -- delete the line, move upwards and goto end
  else
    return ""
  end
end, { remap = false, silent = true, expr = true })

-- Move focus between windows
map(moden, '<S-Left>', '<C-w><C-h>')
map(moden, '<S-Right>', '<C-w><C-l>')
map(moden, '<S-Down>', '<C-w><C-j>')
map(moden, '<S-Up>', '<C-w><C-k>')

-- ================= PLUGINS ===============
-- telescope
local telescope = require('telescope.builtin')

--[[ vim.keymap.set(moden, '<C-p>', function()
  telescope.find_files({
    hidden = true,
    no_ignore = true
  })
end) ]]

local fd_opts = table.concat({
  "--color=never",
  "--type f",
  "--ignore-case",
  "--follow",
  "--hidden",
  "--no-ignore-vcs",
  "--exclude .git",
  "--exclude node_modules",
  "--exclude .venv",
}, " ")

map(moden, "<C-p>", function ()
  local fzf = require('fzf-lua')
  fzf.files({
    fd_opts = fd_opts
  })
end)

-- - Symbol Search
map("n", "<leader>ds", telescope.lsp_document_symbols, opts)
map("n", "<leader>ws", telescope.lsp_dynamic_workspace_symbols, opts)
map("n", "<leader>ss", telescope.live_grep, opts)

-- nvim-tree
local nvimTree = require('nvim-tree.api')

map("n", "<leader>to", nvimTree.tree.open, opts)
map("n", "<leader>tt", nvimTree.tree.toggle, opts)
map("n", "<leader>ti", function() nvimTree.tree.open({ find_file = true }) end, opts)

-- barbar (tabline)
map(modenxi, "<M-C-Left>", "<cmd>BufferPrevious<CR>", opts)
map(modenxi, "<M-C-Right>", "<cmd>BufferNext<CR>", opts)
map("n", "<C-w>", "<cmd>BufferClose<CR>", { remap = false, silent = true, nowait = true })

-- =================================

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
