local opt = vim.opt

-- line numbers
opt.number = true
opt.relativenumber = true

-- indentation
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- wrap
opt.wrap = true

-- copy/paste
opt.clipboard = { "unnamedplus" }

-- search settings
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- gui
opt.cursorline = false
opt.termguicolors = true
opt.guicursor = "n-v-o-r:block-blinkwait800,i:ver10"
opt.signcolumn = "yes"

opt.splitright = true
opt.splitbelow = true

-- remove comment continuation
opt.formatoptions:remove('c')
opt.formatoptions:remove('r')
opt.formatoptions:remove('o')
