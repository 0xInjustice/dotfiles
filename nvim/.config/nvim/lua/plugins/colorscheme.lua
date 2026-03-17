-- lua/colorscheme.lua
local M = {}

M.setup = function()
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
	}

	vim.cmd("highlight clear")
	vim.o.termguicolors = true
	-- vim.o.background = "dark"

	-- Core highlights
	vim.api.nvim_set_hl(0, "Normal", { fg = colors.fg, bg = colors.bg })
	vim.api.nvim_set_hl(0, "Comment", { fg = colors.green, italic = true })
	vim.api.nvim_set_hl(0, "String", { fg = colors.cyan })
	vim.api.nvim_set_hl(0, "Keyword", { fg = colors.portage, bold = true })
	vim.api.nvim_set_hl(0, "Function", { fg = colors.blue })
	vim.api.nvim_set_hl(0, "Type", { fg = colors.pink, bold = true })
	vim.api.nvim_set_hl(0, "Constant", { fg = colors.red })
	vim.api.nvim_set_hl(0, "Identifier", { fg = colors.white })

	-- Markdown highlights
	vim.api.nvim_set_hl(0, "markdownH1", { fg = colors.portage, bold = true })
	vim.api.nvim_set_hl(0, "markdownH2", { fg = colors.portage, bold = true })
	vim.api.nvim_set_hl(0, "markdownH3", { fg = colors.portage, bold = true })
	vim.api.nvim_set_hl(0, "markdownLinkText", { fg = colors.cyan, underline = true })
	vim.api.nvim_set_hl(0, "markdownBlockquote", { fg = colors.green, italic = true })
end

M.setup()

return M
