-- ensure asdf binaries are visible to Neovim
vim.env.PATH = table.concat({
  vim.fn.expand("~/.asdf/shims"),
  vim.fn.expand("~/.asdf/bin"),
  vim.env.PATH,
}, ":")
require("config.lazy")
require("config.keymaps")
require("config.lsp")
-- Set Vim settings using Lua
vim.opt.compatible = false -- disable compatibility to old-time vi
vim.opt.showmatch = true -- show matching brackets
vim.opt.ignorecase = true -- case insensitive search
vim.opt.mouse = "a" -- enable mouse for all modes
vim.opt.hlsearch = true -- highlight search results
vim.opt.incsearch = true -- incremental search
vim.opt.tabstop = 4 -- number of columns occupied by a tab
vim.opt.softtabstop = 4 -- see multiple spaces as tabstops so <BS> does the right thing
vim.opt.expandtab = true -- converts tabs to spaces
vim.opt.shiftwidth = 4 -- width for auto-indents
vim.opt.autoindent = true -- indent a new line the same amount as the line just typed
vim.opt.number = true -- add line numbers
vim.opt.wildmode = { "longest", "list" } -- get bash-like tab completions
vim.cmd("filetype plugin indent on") -- allow auto-indenting depending on file type
vim.cmd("syntax on") -- enable syntax highlighting
vim.opt.clipboard = "unnamedplus" -- use system clipboard
vim.opt.cursorline = true -- highlight current cursor line
vim.opt.ttyfast = true -- speed up scrolling in Vim
vim.opt.termguicolors = true -- enable 24-bit RGB colors
