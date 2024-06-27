
-- set the default colorscheme on startup
vim.cmd.colorscheme("nord")

function PickColorscheme()
  local telescope = require("telescope.builtin")
  telescope.colorscheme()
end
