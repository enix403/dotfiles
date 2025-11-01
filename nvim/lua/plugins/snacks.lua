-- TODO: this might break if ascii is not yet installed. Make sure to
-- manage this correctly inside this file's dependencies table below and
-- require it inside the opts function
local asciiart = require("ascii")

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

    opts.dashboard = {
      preset = {
        -- header = table.concat(require("ascii").art.gaming.pacman, "\n"),
        -- header = table.concat(asciiart.art.gaming.pacman.basic, "\n"),
        -- header = table.concat(asciiart.art.text.slogons.make_cool_stuff, "\n"),
        -- header = table.concat(asciiart.art.text.slogons.arch_btw_bulbhead, "\n"),
        header = table.concat(asciiart.art.text.slogons.arch_btw_doom, "\n"),
        -- header = table.concat(asciiart.art.text.neovim.sharp, "\n"),
        -- header = table.concat(asciiart.art.text.neovim.dos_rebel, "\n"),
        -- header = table.concat(asciiart.art.text.neovim.bloody, "\n"),
        -- header = table.concat(asciiart.art.text.neovim.delta_corps_priest1, "\n"),
        -- header = table.concat(asciiart.art.text.neovim.elite, "\n"),
        -- header = table.concat(asciiart.art.text.neovim.the_edge, "\n"),
      },
    }

    return opts
  end
}
