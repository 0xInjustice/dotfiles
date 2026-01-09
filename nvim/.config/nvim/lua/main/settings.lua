vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.backspace = "indent,eol,start"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.laststatus = 2
vim.opt.title = true

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.autoindent = true
vim.opt.foldmethod = indent

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false

vim.opt.termguicolors = true
vim.opt.background = dark
vim.opt.syntax = enable

vim.opt.visualbell = true
vim.opt.history = 1000
vim.opt.spell = true

vim.opt.updatetime = 300
vim.opt.wildmode = "longest,list"

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"

vim.opt.completeopt = menuone, noselect
vim.opt.grepprg = rg --vimgrep
vim.opt.inccommand = split
vim.opt.shortmess:append("c")
vim.opt.signcolumn = yes
