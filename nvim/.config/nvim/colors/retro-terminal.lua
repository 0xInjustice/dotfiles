local M = {}

M.colors = {
	black = "#000000",
	red = "#800000",
	green = "#008000",
	yellow = "#808000",
	blue = "#000080",
	magenta = "#800080",
	cyan = "#00ffff",
	white = "#ffffff",
}

function M.setup()
	local c = M.colors
	vim.cmd("highlight clear")
	if vim.fn.exists("syntax_on") then
		vim.cmd("syntax reset")
	end
	vim.o.background = "dark"
	vim.o.termguicolors = true

	-- Basic
	vim.api.nvim_set_hl(0, "Normal", { fg = c.white, bg = c.black })
	vim.api.nvim_set_hl(0, "CursorLine", { bg = "#101010" })
	vim.api.nvim_set_hl(0, "LineNr", { fg = "#555555" })
	vim.api.nvim_set_hl(0, "CursorLineNr", { fg = c.white, bold = true })
	vim.api.nvim_set_hl(0, "Visual", { bg = "#303030" })
	vim.api.nvim_set_hl(0, "StatusLine", { fg = c.white, bg = "#202020" })
	vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#555555", bg = "#101010" })
	vim.api.nvim_set_hl(0, "Pmenu", { fg = c.white, bg = "#101010" })
	vim.api.nvim_set_hl(0, "PmenuSel", { fg = c.black, bg = c.yellow })

	-- Syntax
	vim.api.nvim_set_hl(0, "Comment", { fg = c.green, italic = true })
	vim.api.nvim_set_hl(0, "String", { fg = c.cyan })
	vim.api.nvim_set_hl(0, "Number", { fg = c.yellow })
	vim.api.nvim_set_hl(0, "Boolean", { fg = c.yellow, bold = true })
	vim.api.nvim_set_hl(0, "Function", { fg = c.red })
	vim.api.nvim_set_hl(0, "Identifier", { fg = c.white })
	vim.api.nvim_set_hl(0, "Constant", { fg = c.yellow })
	vim.api.nvim_set_hl(0, "Type", { fg = c.blue })
	vim.api.nvim_set_hl(0, "Keyword", { fg = c.magenta, bold = true })
	vim.api.nvim_set_hl(0, "Operator", { fg = c.magenta })

	-- Markdown
	vim.api.nvim_set_hl(0, "markdownHeadingDelimiter", { fg = c.magenta, bold = true })
	vim.api.nvim_set_hl(0, "markdownHeading", { fg = c.magenta, bold = true })
	vim.api.nvim_set_hl(0, "markdownLinkText", { fg = c.cyan, underline = true })
	vim.api.nvim_set_hl(0, "markdownBlockquote", { fg = c.green, italic = true })
	vim.api.nvim_set_hl(0, "markdownCode", { fg = c.yellow })
end

-- Apply colorscheme
M.setup()
vim.cmd("colorscheme mycolors")

return M
