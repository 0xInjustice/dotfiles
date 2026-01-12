return {
	"saghen/blink.cmp",
	version = "1.*",
	lazy = false,

	dependencies = {
		"rafamadriz/friendly-snippets",
		"L3MON4D3/LuaSnip",
	},

	opts = {
		-- === KEYMAPS ===
		-- Replaces: pumvisible() ? <C-y> : <CR>
		keymap = {
			preset = "none",

			["<CR>"] = {
				function(cmp)
					if cmp.is_visible() then
						return cmp.accept()
					end
					return "\n"
				end,
				"fallback",
			},

			["<C-j>"] = { "select_next" },
			["<C-k>"] = { "select_prev" },
			["<C-e>"] = { "hide" },
			["<C-Space>"] = { "show" },
		},

		-- === APPEARANCE ===
		appearance = {
			nerd_font_variant = "mono",
		},

		-- === COMPLETION CORE ===
		completion = {
			keyword = {
				range = "full",
			},

			menu = {
				auto_show = true, -- manual only
			},

			list = {
				selection = {
					preselect = false,
					auto_insert = false,
				},
			},

			documentation = {
				auto_show = true,
			},

			accept = {
				auto_brackets = {
					enabled = false,
				},
			},

			ghost_text = {
				enabled = true,
			},
		},

		-- === SOURCES ===
		sources = {
			default = {
				"lsp",
				"path",
				"snippets",
				"buffer", -- only when LSP returns nothing
			},
		},

		-- === SNIPPETS ===
		snippets = {
			preset = "luasnip", -- change to 'default' if you don’t use luasnip
		},

		-- === SIGNATURE HELP ===
		signature = {
			enabled = false,
		},

		-- === FUZZY MATCHER ===
		fuzzy = {
			implementation = "prefer_rust_with_warning",
		},
	},

	opts_extend = { "sources.default" },
}
