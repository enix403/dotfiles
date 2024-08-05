require('telescope').setup({
  defaults = {
    file_ignore_patterns = {
      "node_modules",
      ".git",
      "package-lock.json",
      "pnpm-lock.yaml",
      "yarn.lock",
    }
  }
})
