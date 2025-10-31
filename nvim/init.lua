-- https://sw.kovidgoyal.net/kitty/mapping/#conditional-mappings-depending-on-the-state-of-the-focused-window
vim.api.nvim_create_autocmd({ "VimEnter", "VimResume" }, {
  group = vim.api.nvim_create_augroup("KittySetVarVimEnter", { clear = true }),
  callback = function()
    -- Temporarily hide the screen to avoid flicker
    -- vim.cmd("silent! set noshowmode noruler laststatus=0")
    -- vim.cmd("silent! redraw!")

    -- -- Set Kitty spacing to zero
    -- vim.fn.jobstart(
    --   { "kitty", "@", "set-spacing", "padding=0", "margin=0" },
    --   {
    --     on_exit = function()
    --       -- Once kitty finishes, trigger a redraw
    --       vim.schedule(function()
    --         vim.cmd("redraw!")
    --       end)
    --     end,
    --   }
    -- )

    io.stdout:write("\x1b]1337;SetUserVar=in_neovim=MQo\007")
  end,
})

vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
  group = vim.api.nvim_create_augroup("KittyUnsetVarVimLeave", { clear = true }),
  callback = function()
    -- Restore Kitty spacing to default
    -- vim.fn.jobstart(
    --   { "kitty", "@", "set-spacing", "margin=default", "padding=default" },
    --   { detach = true }
    -- )

    io.stdout:write("\x1b]1337;SetUserVar=in_neovim\007")
  end,
})

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
