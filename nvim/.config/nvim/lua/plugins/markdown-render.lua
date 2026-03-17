return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		local colors = {
			bg = "#22252a",
			fg = "#ffffff",
			red = "#ff3b3b",
			green = "#50fa7b",
			pink = "#af46f5",
			blue = "#32a6d5",
			portage = "#9ea3f3",
			cyan = "#8be9fd",
			white = "#dde3ea",
			gray = "#6b7089",
		}

		require("render-markdown").setup({
			enabled = true,
			render_modes = { "n", "c", "t" },

			completions = {
				coq = { enabled = true },
			},

			anti_conceal = {
				enabled = true,
				disabled_modes = false,
				above = 0,
				below = 0,
				ignore = {
					code_background = true,
					indent = true,
					sign = true,
					virtual_lines = true,
				},
			},

			quote = { repeat_linebreak = true },

			win_options = {
				showbreak = { default = "", rendered = "  " },
				breakindent = { default = false, rendered = true },
				breakindentopt = { default = "", rendered = "" },
			},

			checkbox = {
				checked = { scope_highlight = "@markup.strikethrough" },
			},

			code = {
				style = "normal",
				border = "thick",
			},

			dash = {
				enabled = true,
				render_modes = false,
				icon = "─",
				width = "full",
				left_margin = 0,
				highlight = "RenderMarkdownDash",
			},

			heading = {
				width = { "block" },
			},

			indent = { enabled = true },

			link = { image = "󰋵 " },

			bullet = {
				enabled = true,
				render_modes = false,
				icons = { "●", "○", "◆", "◇" },
				highlight = "RenderMarkdownBullet",
			},

			paragraph = {
				enabled = true,
				render_modes = true,
				left_margin = 0,
				indent = 0,
				min_width = 0,
			},
		})

		--------------------------------------------------
		-- ONLY FIX: override plugin highlight groups
		--------------------------------------------------

		-- headings (remove color noise, keep hierarchy)
		vim.api.nvim_set_hl(0, "RenderMarkdownH1", { fg = colors.fg, bold = true })
		vim.api.nvim_set_hl(0, "RenderMarkdownH2", { fg = colors.fg, bold = true })
		vim.api.nvim_set_hl(0, "RenderMarkdownH3", { fg = colors.white, bold = true })
		vim.api.nvim_set_hl(0, "RenderMarkdownH4", { fg = colors.white })
		vim.api.nvim_set_hl(0, "RenderMarkdownH5", { fg = colors.gray })
		vim.api.nvim_set_hl(0, "RenderMarkdownH6", { fg = colors.gray })

		-- remove background blocks (critical)
		for i = 1, 6 do
			vim.api.nvim_set_hl(0, "RenderMarkdownH" .. i .. "Bg", { bg = colors.bg })
		end

		-- code (single consistent tone)
		vim.api.nvim_set_hl(0, "RenderMarkdownCode", { fg = colors.green, bg = colors.bg })
		vim.api.nvim_set_hl(0, "RenderMarkdownCodeInline", { fg = colors.green })

		-- structure (de-emphasized)
		vim.api.nvim_set_hl(0, "RenderMarkdownBullet", { fg = colors.gray })
		vim.api.nvim_set_hl(0, "RenderMarkdownDash", { fg = colors.gray })
		vim.api.nvim_set_hl(0, "RenderMarkdownQuote", { fg = colors.gray, italic = true })

		-- links (single accent)
		vim.api.nvim_set_hl(0, "RenderMarkdownLink", { fg = colors.blue })
	end,
}
