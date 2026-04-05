-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- TODO: categorize in two: Fixing existing shortcuts vs adding new

-- NOTE: It appears it is no longer needed. Explore
-- add an "actual" indent (with spaces/tabs) instead of just
-- putting a cursor there (and thus unindenting the line when the
-- moves away)
-- map("i", "<CR>", "<CR> <BS>")

-- BUILT INTO LAZY VIM
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
-- vim.api.nvim_create_autocmd('TextYankPost', {
--   desc = 'Highlight when yanking (copying) text',
--   group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
--   callback = function()
--     vim.highlight.on_yank()
--   end,
-- })

-- local folder = (...):match("(.-)[^%.]+$")
local folder = "config.keymaps."
require(folder .. "basic")
require(folder .. "window")
require(folder .. "scroll")
require(folder .. "files")
require(folder .. "ctrldel")
require(folder .. "moveword")
require(folder .. "terminal")