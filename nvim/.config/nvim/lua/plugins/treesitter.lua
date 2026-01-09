return {
	"nvim-treesitter/nvim-treesitter",
	event = "BufReadPost",
	build = ":TSUpdate",
	opts = {
		ensure_installed = { "c", "cpp", "lua", "python", "javascript", "typescript", "html", "css" },
		sync_install = false,
		auto_install = true,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = true,
		},
		indent = {
			enable = true,
		},
	},
}
