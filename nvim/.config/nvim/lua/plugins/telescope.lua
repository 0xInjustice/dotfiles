return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local transform_mod = require("telescope.actions.mt").transform_mod

		require("telescope").setup({
			defaults = {
				initial_mode = "normal",
				mappings = {
					i = {
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
					},
				},
			},
		})

		telescope.load_extension("fzf")
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Search Text" })
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "List Buffers" })
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })
		vim.keymap.set("n", "<leader>fm", builtin.marks, { desc = "Marks" })
		vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Keymaps" })
		vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "Commands" })
		vim.keymap.set("n", "<leader>fch", builtin.command_history, { desc = "Command History" })
		vim.keymap.set("n", "<leader>fsh", builtin.search_history, { desc = "Search History" })
		vim.keymap.set("n", "<leader>fcs", builtin.colorscheme, { desc = "Colorschemes" })
		vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Old Files" })
		vim.keymap.set("n", "<leader>fq", builtin.quickfix, { desc = "Quickfix List" })
		vim.keymap.set("n", "<leader>fl", builtin.loclist, { desc = "Location List" })
		vim.keymap.set("n", "<leader>fj", builtin.jumplist, { desc = "Jumplist" })
		vim.keymap.set("n", "<leader>ft", builtin.tags, { desc = "Tags" })
	end,
}
