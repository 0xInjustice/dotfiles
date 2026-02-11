return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("render-markdown").setup({
			enabled = true,
			render_modes = { "n", "c", "t" },

			completions = {
				coq = {
					enabled = true,
				},
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
				showbreak = {
					default = '',
					rendered = '  ',
				},
				breakindent = {
					default = false,
					rendered = true,
				},
				breakindentopt = {
					default = '',
					rendered = '',
				},
			},
			checkbox = { checked = { scope_highlight = '@markup.strikethrough' } },
			code = {
				style = 'normal',
				border = 'thick',
			},
			dash = {
				enabled = true,
				render_modes = false,
				icon = '─',
				width = 'full',
				left_margin = 0,
				priority = nil,
				highlight = 'RenderMarkdownDash',
			},
			heading = {
				width = { 'full' },
			},
			indent = { enabled = true },
			link = { image = '󰋵 ' },
			bullet = {
				enabled = true,
				render_modes = false,
				icons = { '●', '○', '◆', '◇' },
				ordered_icons = function(ctx)
					local value = vim.trim(ctx.value)
					local index = tonumber(value:sub(1, #value - 1))
					return ('%d.'):format(index > 1 and index or ctx.index)
				end,
				left_pad = 0,
				right_pad = 0,
				highlight = 'RenderMarkdownBullet',
				scope_highlight = {},
				scope_priority = nil,
			},
			paragraph = {
				enabled = true,
				render_modes = true,
				left_margin = 0,
				indent = 0,
				min_width = 0,
			},
		})

	end,
}
