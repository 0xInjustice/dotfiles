-- lua/colorscheme.lua
local M = {}

M.setup = function()
	local colors = {
		bg = "#000000", -- pure black background
		fg = "#ffffff", -- bright white foreground
		red = "#ff5555",
		green = "#50fa7b",
		yellow = "#f1fa8c",
		blue = "#6272a4",
		magenta = "#ff79c6",
		cyan = "#8be9fd",
		white = "#f8f8f2",
	}

	vim.cmd("highlight clear")
	vim.o.termguicolors = true
	vim.o.background = "dark"

	-- Core highlights
	vim.api.nvim_set_hl(0, "Normal", { fg = colors.fg, bg = colors.bg })
	vim.api.nvim_set_hl(0, "Comment", { fg = colors.green, italic = true })
	vim.api.nvim_set_hl(0, "String", { fg = colors.cyan })
	vim.api.nvim_set_hl(0, "Keyword", { fg = colors.magenta, bold = true })
	vim.api.nvim_set_hl(0, "Function", { fg = colors.blue })
	vim.api.nvim_set_hl(0, "Type", { fg = colors.yellow })
	vim.api.nvim_set_hl(0, "Constant", { fg = colors.red })
	vim.api.nvim_set_hl(0, "Identifier", { fg = colors.white })

	-- Markdown highlights
	vim.api.nvim_set_hl(0, "markdownH1", { fg = colors.magenta, bold = true })
	vim.api.nvim_set_hl(0, "markdownH2", { fg = colors.magenta, bold = true })
	vim.api.nvim_set_hl(0, "markdownH3", { fg = colors.magenta, bold = true })
	vim.api.nvim_set_hl(0, "markdownLinkText", { fg = colors.cyan, underline = true })
	vim.api.nvim_set_hl(0, "markdownBlockquote", { fg = colors.green, italic = true })
end

M.setup()

return M
