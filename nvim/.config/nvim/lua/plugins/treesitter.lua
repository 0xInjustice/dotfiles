-- Treesitter for syntax highlighting
return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	run = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"python",
				"lua",
				"c",
				"cpp",
				"bash",
				"json",
				"yaml",
				"markdown",
				"markdown_inline",
				"c",
				"rust",
			},
			highlight = { enable = true },
		})
	end,
}
