return {
  "folke/snacks.nvim",
  -- opts.picker.sources.files.hidden = true
  -- https://github.com/folke/snacks.nvim/discussions/1322#discussioncomment-14196635
  opts = function(_, opts)
    local sources = opts.picker.sources or {}
    local source_names = { "files", "explorer", "grep", "grep_word", "grep_buffers" }
    local source_opts = {
      hidden = true,
      ignored = true,
      exclude = {
        ".DS_Store",
        "Thumbs.db",
        ".svn",
        ".hg",
        ".git",
        "node_modules",
      },
    }

    for _, name in ipairs(source_names) do
      sources[name] = source_opts
    end

    opts.picker.sources = sources

    opts.terminal.enabled = false

    return opts
  end
}
