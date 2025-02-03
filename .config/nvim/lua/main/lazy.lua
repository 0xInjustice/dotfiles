local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Install lazy.nvim if not installed
if not vim.loop.fs_stat(lazy_path) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazy_path,
	})
end
vim.opt.runtimepath:prepend(lazy_path)

-- Set up Lazy.nvim
require("lazy").setup({
	spec = {
		-- import your plugins
		{ import = "plugins" },
		{ import = "plugins.lsp" },
	},
})
