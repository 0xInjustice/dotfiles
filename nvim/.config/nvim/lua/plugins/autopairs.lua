return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	dependencies = { "saghen/blink.cmp" },
	config = function()
		local npairs = require("nvim-autopairs")
		local blink = require("blink.cmp")

		npairs.setup({
			check_ts = true,
			ts_config = {
				lua = { "string" },
				javascript = { "template_string" },
				java = false,
			},
			-- prevent default <CR> mapping
			map_cr = false,
		})

		-- Unified <CR>: blink.cmp first, autopairs fallback
		vim.keymap.set("i", "<CR>", function()
			if blink.is_visible() then
				if blink.accept({ select = true }) then
					return ""
				end
			end
			return npairs.autopairs_cr()
		end, { expr = true, replace_keycodes = true })
	end,
}
