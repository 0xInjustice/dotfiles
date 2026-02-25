-- retro-terminal colorscheme

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") == 1 then
	vim.cmd("syntax reset")
end

vim.g.colors_name = "retro-terminal"

local c = {
	black = "#000000",
	green = "#00ff00",
	dimgreen = "#008800",
	blue = "#3399ff",
	red = "#ff3333",
	white = "#ffffff",
	magenta = "#aa66ff",
}

local set = vim.api.nvim_set_hl

-- Core UI
set(0, "Normal", { fg = c.green, bg = c.black })
set(0, "NormalNC", { fg = c.green, bg = c.black })
set(0, "Cursor", { fg = c.white, bg = c.black })
set(0, "CursorLine", { bg = c.black })
set(0, "CursorColumn", { bg = c.black })
set(0, "ColorColumn", { bg = c.black })
set(0, "LineNr", { fg = c.dimgreen, bg = c.black })
set(0, "CursorLineNr", { fg = c.white, bg = c.black, bold = true })
set(0, "SignColumn", { fg = c.green, bg = c.black })
set(0, "FoldColumn", { fg = c.dimgreen, bg = c.black })
set(0, "VertSplit", { fg = c.green, bg = c.black })
set(0, "WinSeparator", { fg = c.green, bg = c.black })
set(0, "StatusLine", { fg = c.black, bg = c.green, bold = true })
set(0, "StatusLineNC", { fg = c.black, bg = c.dimgreen })
set(0, "TabLine", { fg = c.black, bg = c.dimgreen })
set(0, "TabLineSel", { fg = c.black, bg = c.blue, bold = true })
set(0, "TabLineFill", { fg = c.green, bg = c.black })
set(0, "Pmenu", { fg = c.green, bg = c.black })
set(0, "PmenuSel", { fg = c.black, bg = c.green })
set(0, "PmenuSbar", { bg = c.black })
set(0, "PmenuThumb", { bg = c.green })
set(0, "Visual", { reverse = true })
set(0, "Search", { fg = c.black, bg = c.magenta })
set(0, "IncSearch", { fg = c.black, bg = c.white })
set(0, "MatchParen", { fg = c.black, bg = c.magenta, bold = true })
set(0, "Directory", { fg = c.blue, bg = c.black })
set(0, "Title", { fg = c.white, bg = c.black, bold = true })
set(0, "ErrorMsg", { fg = c.red, bg = c.black, bold = true })
set(0, "WarningMsg", { fg = c.red, bg = c.black })
set(0, "ModeMsg", { fg = c.green, bg = c.black, bold = true })
set(0, "MoreMsg", { fg = c.green, bg = c.black })
set(0, "Question", { fg = c.blue, bg = c.black })

-- Syntax
set(0, "Comment", { fg = c.dimgreen, bg = c.black })
set(0, "Keyword", { fg = c.green, bg = c.black, bold = true })
set(0, "Statement", { fg = c.green, bg = c.black, bold = true })
set(0, "Conditional", { fg = c.green, bg = c.black, bold = true })
set(0, "Repeat", { fg = c.green, bg = c.black, bold = true })
set(0, "Label", { fg = c.green, bg = c.black, bold = true })
set(0, "Operator", { fg = c.white, bg = c.black })
set(0, "Delimiter", { fg = c.white, bg = c.black })
set(0, "Identifier", { fg = c.blue, bg = c.black })
set(0, "Function", { fg = c.blue, bg = c.black })
set(0, "Type", { fg = c.white, bg = c.black, bold = true })
set(0, "Structure", { fg = c.white, bg = c.black, bold = true })
set(0, "Constant", { fg = c.magenta, bg = c.black })
set(0, "Number", { fg = c.magenta, bg = c.black })
set(0, "Boolean", { fg = c.magenta, bg = c.black })
set(0, "Float", { fg = c.magenta, bg = c.black })
set(0, "String", { fg = c.green, bg = c.black })
set(0, "Character", { fg = c.green, bg = c.black })
set(0, "PreProc", { fg = c.blue, bg = c.black })
set(0, "Include", { fg = c.blue, bg = c.black })
set(0, "Define", { fg = c.blue, bg = c.black })
set(0, "Macro", { fg = c.blue, bg = c.black })
set(0, "Special", { fg = c.white, bg = c.black })
set(0, "Underlined", { fg = c.green, bg = c.black, underline = true })
set(0, "Error", { fg = c.red, bg = c.black, bold = true })
set(0, "Todo", { fg = c.black, bg = c.magenta, bold = true })

-- Treesitter
set(0, "@comment", { link = "Comment" })
set(0, "@keyword", { link = "Keyword" })
set(0, "@keyword.function", { link = "Keyword" })
set(0, "@function", { link = "Function" })
set(0, "@function.call", { link = "Function" })
set(0, "@type", { link = "Type" })
set(0, "@constant", { link = "Constant" })
set(0, "@number", { link = "Number" })
set(0, "@boolean", { link = "Boolean" })
set(0, "@string", { link = "String" })
set(0, "@operator", { link = "Operator" })
set(0, "@punctuation", { link = "Delimiter" })
set(0, "@include", { link = "Include" })
set(0, "@variable", { fg = c.green, bg = c.black })

-- Diagnostics
set(0, "DiagnosticError", { fg = c.red, bg = c.black, bold = true })
set(0, "DiagnosticWarn", { fg = c.red, bg = c.black })
set(0, "DiagnosticInfo", { fg = c.blue, bg = c.black })
set(0, "DiagnosticHint", { fg = c.green, bg = c.black })
set(0, "DiagnosticUnderlineError", { undercurl = true, sp = c.red })
set(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = c.red })
set(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = c.blue })
set(0, "DiagnosticUnderlineHint", { undercurl = true, sp = c.green })

-- Diff / Git
set(0, "DiffAdd", { fg = c.green, bg = c.black })
set(0, "DiffChange", { fg = c.blue, bg = c.black })
set(0, "DiffDelete", { fg = c.red, bg = c.black })
set(0, "DiffText", { fg = c.black, bg = c.blue, bold = true })
set(0, "GitSignsAdd", { fg = c.green, bg = c.black })
set(0, "GitSignsChange", { fg = c.blue, bg = c.black })
set(0, "GitSignsDelete", { fg = c.red, bg = c.black })

-- Completion (nvim-cmp)
set(0, "CmpItemAbbr", { fg = c.green, bg = c.black })
set(0, "CmpItemAbbrMatch", { fg = c.white, bg = c.black, bold = true })
set(0, "CmpItemKind", { fg = c.blue, bg = c.black })
set(0, "CmpItemMenu", { fg = c.dimgreen, bg = c.black })
