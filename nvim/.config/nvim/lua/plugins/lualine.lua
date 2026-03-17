-- lua/lualine.lua
local colors = {
	bg = "#22252a", -- void black
	fg = "#ffffff", -- bright white foreground
	red = "#ff3b3b", -- mars red
	green = "#50fa7b",
	pink = "#af46f5", -- heliotrope
	blue = "#32a6d5", -- scooter
	portage = "#9ea3f3", -- portage
	cyan = "#8be9fd",
	white = "#dde3ea", -- drift silver
	surface = "#1a2a3f",
}

local theme = {
	normal = {
		a = { fg = colors.bg, bg = colors.green, gui = "bold" },
		b = { fg = colors.fg, bg = colors.surface },
		c = { fg = colors.white, bg = colors.bg },
	},
	insert = {
		a = { fg = colors.bg, bg = colors.blue, gui = "bold" },
	},
	visual = {
		a = { fg = colors.bg, bg = colors.pink, gui = "bold" },
	},
	replace = {
		a = { fg = colors.bg, bg = colors.red, gui = "bold" },
	},
	command = {
		a = { fg = colors.bg, bg = colors.portage, gui = "bold" },
	},
	inactive = {
		a = { fg = colors.white, bg = colors.bg },
		b = { fg = colors.white, bg = colors.bg },
		c = { fg = colors.white, bg = colors.bg },
	},
}

require("lualine").setup({
	options = {
		theme = theme,
		section_separators = { left = "", right = "" },
		component_separators = { left = "", right = "" },
		globalstatus = true,
	},

	sections = {
		lualine_a = { { "mode", separator = { right = "" } } },

		lualine_b = {
			{ "branch", color = { fg = colors.white, bg = colors.surface } },
			{ "diff", color = { bg = colors.surface } },
		},

		lualine_c = {
			{
				"filename",
				path = 1,
				color = { fg = colors.green },
			},
		},

		lualine_x = {
			{ "filetype", color = { fg = colors.white } },
		},

		lualine_y = {
			{ "progress", color = { fg = colors.white } },
		},

		lualine_z = {
			{ "location", color = { fg = colors.bg } },
		},
	},

	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
})
