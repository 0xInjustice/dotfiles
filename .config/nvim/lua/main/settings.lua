vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"

vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.wrap = false

vim.opt.termguicolors = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.shiftwidth = 4

vim.opt.updatetime = 300
vim.opt.wildmode = "longest,list"
vim.opt.colorcolumn = "80" -- replaces vim.opt.cc=80
vim.opt.cursorline = true

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"
vim.opt.signcolumn = "yes"
