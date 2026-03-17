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

	-- headings: neutral + weight hierarchy
	vim.api.nvim_set_hl(0, "markdownH1", { fg = colors.fg, bold = true, bg = colors.bg })
	vim.api.nvim_set_hl(0, "markdownH2", { fg = colors.fg, bold = true })
	vim.api.nvim_set_hl(0, "markdownH3", { fg = colors.white, bold = true })
	vim.api.nvim_set_hl(0, "markdownH4", { fg = colors.white })
	vim.api.nvim_set_hl(0, "markdownH5", { fg = colors.gray })
	vim.api.nvim_set_hl(0, "markdownH6", { fg = colors.gray })

	-- heading markers (#)
	vim.api.nvim_set_hl(0, "markdownHeadingDelimiter", { fg = colors.gray })

	-- emphasis
	vim.api.nvim_set_hl(0, "markdownItalic", { italic = true })
	vim.api.nvim_set_hl(0, "markdownBold", { bold = true })
	vim.api.nvim_set_hl(0, "markdownBoldItalic", { bold = true, italic = true })

	-- links: single accent color
	vim.api.nvim_set_hl(0, "markdownLinkText", { fg = colors.blue, underline = true })
	vim.api.nvim_set_hl(0, "markdownUrl", { fg = colors.cyan, underline = true })

	-- code
	vim.api.nvim_set_hl(0, "markdownCode", { fg = colors.green })
	vim.api.nvim_set_hl(0, "markdownCodeBlock", { fg = colors.green })
	vim.api.nvim_set_hl(0, "markdownCodeDelimiter", { fg = colors.gray })

	-- lists
	vim.api.nvim_set_hl(0, "markdownListMarker", { fg = colors.gray })

	-- blockquote
	vim.api.nvim_set_hl(0, "markdownBlockquote", { fg = colors.gray, italic = true })

	-- horizontal rule
	vim.api.nvim_set_hl(0, "markdownRule", { fg = colors.gray })

	-- tables
	vim.api.nvim_set_hl(0, "markdownTableDelimiter", { fg = colors.gray })

	-- inline html (often noisy)
	vim.api.nvim_set_hl(0, "markdownHtmlTag", { fg = colors.gray })
	vim.api.nvim_set_hl(0, "markdownHtmlEndTag", { fg = colors.gray })
end

M.setup()

return M
