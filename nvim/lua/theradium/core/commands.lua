vim.api.nvim_create_user_command("ReloadConfig", function()
  vim.cmd.source("~/.config/nvim/init.lua")
end, {})
