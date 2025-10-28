return {
  "folke/snacks.nvim",
  -- opts.picker.sources.files.hidden = true
  opts = {
    picker = {
      sources = {
        files = {
          hidden = true,
        },
      },
      hidden = true, -- for hidden files
      ignored = true, -- for .gitignore files
    },
  },
}
