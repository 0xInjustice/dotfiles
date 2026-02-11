return {
	"EdenEast/nightfox.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("nightfox").setup({
			options = {
				transparent = true,
				dim_inactive = true,
				styles = {
					comments = "italic",
					keywords = "bold",
					types = "italic,bold",
				},
			},
		})
	end,
	init = function()
		vim.cmd.colorscheme("carbonfox") -- my favorite
	end,
}
