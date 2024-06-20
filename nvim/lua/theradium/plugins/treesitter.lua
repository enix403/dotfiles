require('nvim-treesitter.configs').setup({
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = {
    "javascript",
    "typescript",
    "html",
    "css",

    "c",
    "cpp",
    "rust",
    "python",

    "json",

    "lua",
    "vim",
    "vimdoc",
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = true,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  highlight = {
    enable = true,

    -- disable tree sitter highlighting for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,
  }
})
