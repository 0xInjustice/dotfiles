-- Treesitter for syntax highlighting
return    {
	"nvim-treesitter/nvim-treesitter",
	run = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "python", "lua", "bash", "json", "yaml", "markdown", "markdown_inline" },
			highlight = { enable = true },
		})
	end,
}


