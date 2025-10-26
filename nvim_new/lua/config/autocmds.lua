-- Disable Spell check for everyfile
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.spell = false
  end,
})
