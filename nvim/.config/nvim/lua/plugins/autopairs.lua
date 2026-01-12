return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		local npairs = require("nvim-autopairs")

		npairs.setup({
			check_ts = true,
			ts_config = {
				lua = { "string" },
				javascript = { "template_string" },
				java = false,
			},
			-- CRITICAL: Disable the plugin's default Enter mapping
			-- This stops it from fighting with COQ
			map_cr = false,
		})

		-- Custom Keymap: Handles both COQ completion and Autopairs newlines
		vim.keymap.set("i", "<CR>", function()
			-- 1. If the COQ menu is open...
			if vim.fn.pumvisible() ~= 0 then
				-- Check if an item is selected
				if vim.fn.complete_info({ "selected" }).selected ~= -1 then
					-- Confirm selection
					return vim.api.nvim_replace_termcodes("<C-y>", true, true, true)
				else
					-- If no item selected, select the first one then confirm
					return vim.api.nvim_replace_termcodes("<C-n><C-y>", true, true, true)
				end
			end

			-- 2. If menu is NOT open, let autopairs handle the Enter key (smart indentation)
			return npairs.autopairs_cr()
		end, { expr = true, replace_keycodes = false })
	end,
}
