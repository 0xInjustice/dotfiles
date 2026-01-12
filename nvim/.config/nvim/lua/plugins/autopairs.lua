return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
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
			-- blink completion visible
			if blink.is_visible() then
				-- accept selected item, or first item if none selected
				return blink.accept({ select = true })
			end

			-- no completion menu → autopairs newline handling
			return npairs.autopairs_cr()
		end, { expr = true, replace_keycodes = false })
	end,
}
