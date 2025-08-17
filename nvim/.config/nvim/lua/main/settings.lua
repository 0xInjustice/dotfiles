-- ========================
-- Core Settings
-- ========================
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.backspace = "indent,eol,start"

-- Search
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.wrap = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Colors & Cursor
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"

-- Tabs: 8-space tabs for all files
vim.opt.tabstop = 4 -- Visual width of tab
vim.opt.softtabstop = 4 -- Editing width of tab
vim.opt.shiftwidth = 4 -- Indentation width
vim.opt.expandtab = false -- Use real tabs (change to true for spaces)
vim.opt.autoindent = true

-- Performance & Undo
vim.opt.updatetime = 300
vim.opt.wildmode = "longest,list"
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"

-- ========================
-- Autoformat on Save using LSP
-- ========================
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		pcall(function()
			vim.lsp.buf.format({ async = false })
		end)
	end,
})
