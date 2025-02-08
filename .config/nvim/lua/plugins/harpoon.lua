return {
	"ThePrimeagen/harpoon",
	config = function()
		local mark = require("harpoon.mark")
		local ui = require("harpoon.ui")

		require("harpoon").setup()

		local keymap = vim.keymap.set
		keymap("n", "<leader>aa", mark.add_file)
		keymap("n", "<leader>as", ui.toggle_quick_menu)
	end,
}
