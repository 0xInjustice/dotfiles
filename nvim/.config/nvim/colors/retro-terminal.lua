-- =====================================================================
-- RETRO-TERMINAL COLORSCHEME
-- =====================================================================

-- 1. Reset Environment
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end

-- 2. Define Global Identity
vim.opt.background = "dark"
vim.g.colors_name = "retro-terminal"

-- 3. Palette
local colors = {
    bg         = "#000000",
    fg         = "#dde3ea",
    comment    = "#50fa7b",
    func       = "#32a6d5",
    type       = "#8be9fd",
    keyword    = "#af46f5",
    preproc    = "#9ea3f3",
    constant   = "#ff5555",
    operator   = "#ff5555",
    string     = "#7ee787",
    number     = "#ff8c42",
    cursorline = "#121212",
    popup      = "#101010",
    border     = "#44475a",
    selection  = "#2d3748",
    info       = "#32a6d5",
    error      = "#ff5555",
    warning    = "#ff8c42",
    hint       = "#50fa7b",
    success    = "#7ee787",
    muted      = "#777777",
    none       = "NONE",
}

-- 4. Helper Functions
local function hl(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

local function link(group, target)
    vim.api.nvim_set_hl(0, group, { link = target })
end

-- 5. Highlight Definitions

-- Editor UI
hl("Normal",       { fg = colors.fg, bg = colors.bg })
hl("NormalNC",     { fg = colors.fg, bg = colors.bg })
hl("NormalFloat",  { fg = colors.fg, bg = colors.popup })
hl("FloatBorder",  { fg = colors.border, bg = colors.popup })
hl("FloatTitle",   { fg = colors.func, bg = colors.popup, bold = true })
hl("EndOfBuffer",  { fg = colors.bg, bg = colors.bg })
hl("Cursor",       { fg = colors.bg, bg = colors.fg })
hl("CursorLine",   { bg = colors.cursorline })
hl("CursorColumn", { bg = colors.cursorline })
hl("CursorLineNr", { fg = colors.fg, bg = colors.cursorline, bold = true })
hl("LineNr",       { fg = colors.border, bg = colors.bg })
hl("SignColumn",   { fg = colors.border, bg = colors.bg })
hl("FoldColumn",   { fg = colors.border, bg = colors.bg })
hl("Folded",       { fg = colors.muted, bg = colors.cursorline })
hl("StatusLine",   { fg = colors.fg, bg = colors.border })
hl("StatusLineNC", { fg = colors.muted, bg = colors.bg })
hl("WinSeparator", { fg = colors.border, bg = colors.bg })
hl("VertSplit",    { fg = colors.border, bg = colors.bg })
hl("TabLine",      { fg = colors.muted, bg = colors.popup })
hl("TabLineFill",  { fg = colors.none, bg = colors.popup })
hl("TabLineSel",   { fg = colors.fg, bg = colors.selection, bold = true })
hl("Pmenu",        { fg = colors.fg, bg = colors.popup })
hl("PmenuSel",     { fg = colors.fg, bg = colors.selection, bold = true })
hl("PmenuThumb",   { bg = colors.border })
hl("PmenuSbar",    { bg = colors.cursorline })
hl("PmenuKind",    { fg = colors.type, bg = colors.popup })
hl("PmenuExtra",   { fg = colors.muted, bg = colors.popup })
hl("PmenuMatch",   { fg = colors.info, bg = colors.popup, bold = true })
hl("PmenuMatchSel",{ fg = colors.info, bg = colors.selection, bold = true })
hl("Visual",       { bg = colors.selection })
hl("VisualNOS",    { bg = colors.selection })
hl("Search",       { fg = colors.bg, bg = colors.info })
hl("IncSearch",    { fg = colors.bg, bg = colors.error })
hl("CurSearch",    { fg = colors.bg, bg = colors.error })
hl("Substitute",   { fg = colors.bg, bg = colors.error })
hl("MatchParen",   { fg = colors.bg, bg = colors.keyword, bold = true })
hl("ColorColumn",  { bg = colors.cursorline })
hl("Directory",    { fg = colors.func })
hl("Question",     { fg = colors.success })
hl("MoreMsg",      { fg = colors.success })
hl("ModeMsg",      { fg = colors.fg, bold = true })
hl("WarningMsg",   { fg = colors.warning })
hl("ErrorMsg",     { fg = colors.error, bold = true })
hl("Error",        { fg = colors.error })
hl("Todo",         { fg = colors.bg, bg = colors.info, bold = true })
hl("Title",        { fg = colors.keyword, bold = true })
hl("NonText",      { fg = colors.border })
hl("Whitespace",   { fg = colors.border })
hl("SpecialKey",   { fg = colors.info })
hl("Conceal",      { fg = colors.border })
hl("QuickFixLine", { bg = colors.selection, bold = true })
hl("WildMenu",     { fg = colors.bg, bg = colors.info })
hl("FloatShadow",  { bg = colors.bg, blend = 80 })
hl("FloatShadowThrough", { bg = colors.bg, blend = 100 })
hl("MsgArea",      { fg = colors.fg, bg = colors.bg })
hl("MsgSeparator", { fg = colors.border, bg = colors.bg })

-- Legacy Syntax Groups
hl("Comment",      { fg = colors.comment })
hl("Constant",     { fg = colors.constant })
hl("String",       { fg = colors.string })
hl("Character",    { fg = colors.string })
hl("Number",       { fg = colors.number })
hl("Boolean",      { fg = colors.number })
hl("Float",        { fg = colors.number })
hl("Identifier",   { fg = colors.fg })
hl("Function",     { fg = colors.func })
hl("Statement",    { fg = colors.keyword })
hl("Conditional",  { fg = colors.keyword })
hl("Repeat",       { fg = colors.keyword })
hl("Label",        { fg = colors.keyword })
hl("Operator",     { fg = colors.operator })
hl("Keyword",      { fg = colors.keyword })
hl("Exception",    { fg = colors.keyword })
hl("PreProc",      { fg = colors.preproc })
hl("Include",      { fg = colors.preproc })
hl("Define",       { fg = colors.preproc })
hl("Macro",        { fg = colors.preproc })
hl("PreCondit",    { fg = colors.preproc })
hl("Type",         { fg = colors.type })
hl("StorageClass", { fg = colors.type })
hl("Structure",    { fg = colors.type })
hl("Typedef",      { fg = colors.type })
hl("Special",      { fg = colors.info })
hl("SpecialChar",  { fg = colors.constant })
hl("Delimiter",    { fg = colors.fg })
hl("Debug",        { fg = colors.warning })
hl("Tag",          { fg = colors.info })
hl("Underlined",   { underline = true })
hl("Ignore",       { fg = colors.muted })

-- Diagnostics
hl("DiagnosticError", { fg = colors.error })
hl("DiagnosticWarn",  { fg = colors.warning })
hl("DiagnosticInfo",  { fg = colors.info })
hl("DiagnosticHint",  { fg = colors.hint })
hl("DiagnosticOk",    { fg = colors.success })

hl("DiagnosticVirtualTextError", { fg = colors.error, bg = colors.cursorline })
hl("DiagnosticVirtualTextWarn",  { fg = colors.warning, bg = colors.cursorline })
hl("DiagnosticVirtualTextInfo",  { fg = colors.info, bg = colors.cursorline })
hl("DiagnosticVirtualTextHint",  { fg = colors.hint, bg = colors.cursorline })
hl("DiagnosticVirtualTextOk",    { fg = colors.success, bg = colors.cursorline })

hl("DiagnosticFloatingError", { fg = colors.error, bg = colors.popup })
hl("DiagnosticFloatingWarn",  { fg = colors.warning, bg = colors.popup })
hl("DiagnosticFloatingInfo",  { fg = colors.info, bg = colors.popup })
hl("DiagnosticFloatingHint",  { fg = colors.hint, bg = colors.popup })
hl("DiagnosticFloatingOk",    { fg = colors.success, bg = colors.popup })

hl("DiagnosticSignError", { fg = colors.error, bg = colors.bg })
hl("DiagnosticSignWarn",  { fg = colors.warning, bg = colors.bg })
hl("DiagnosticSignInfo",  { fg = colors.info, bg = colors.bg })
hl("DiagnosticSignHint",  { fg = colors.hint, bg = colors.bg })
hl("DiagnosticSignOk",    { fg = colors.success, bg = colors.bg })

hl("DiagnosticUnderlineError", { sp = colors.error, undercurl = true })
hl("DiagnosticUnderlineWarn",  { sp = colors.warning, undercurl = true })
hl("DiagnosticUnderlineInfo",  { sp = colors.info, undercurl = true })
hl("DiagnosticUnderlineHint",  { sp = colors.hint, undercurl = true })
hl("DiagnosticUnderlineOk",    { sp = colors.success, undercurl = true })

hl("DiagnosticDeprecated", { sp = colors.error, strikethrough = true })
hl("DiagnosticUnnecessary", { fg = colors.muted, undercurl = true })

-- Diff
hl("DiffAdd",       { bg = colors.selection, fg = colors.success })
hl("DiffDelete",    { bg = colors.selection, fg = colors.error })
hl("DiffChange",    { bg = colors.selection, fg = colors.warning })
hl("DiffText",      { bg = colors.info, fg = colors.bg, bold = true })
hl("DiffAdded",     { fg = colors.success })
hl("DiffRemoved",   { fg = colors.error })
hl("DiffFile",      { fg = colors.info, bold = true })
hl("DiffLine",      { fg = colors.keyword })
hl("DiffIndexLine", { fg = colors.preproc })

-- Spell
hl("SpellBad",   { sp = colors.error, undercurl = true })
hl("SpellCap",   { sp = colors.warning, undercurl = true })
hl("SpellRare",  { sp = colors.info, undercurl = true })
hl("SpellLocal", { sp = colors.hint, undercurl = true })

-- Treesitter
link("@variable",            "Identifier")
link("@variable.builtin",    "Special")
link("@variable.parameter",  "Identifier")
link("@variable.member",     "Identifier")
link("@constant",            "Constant")
link("@constant.builtin",    "Constant")
link("@constant.macro",      "Macro")
link("@string",              "String")
link("@string.escape",       "SpecialChar")
link("@string.regex",        "String")
link("@string.special",      "SpecialChar")
link("@number",              "Number")
link("@number.float",        "Float")
link("@boolean",             "Boolean")
link("@function",            "Function")
link("@function.call",       "Function")
link("@function.builtin",    "Function")
link("@function.macro",      "Macro")
link("@method",              "Function")
link("@method.call",         "Function")
link("@constructor",         "Type")
link("@class",               "Type")
link("@type",                "Type")
link("@type.builtin",        "Type")
link("@type.definition",     "Typedef")
link("@type.qualifier",      "Keyword")
link("@namespace",           "Type")
link("@module",              "Type")
link("@parameter",           "Identifier")
link("@property",            "Identifier")
link("@field",               "Identifier")
link("@operator",            "Operator")
link("@keyword",             "Keyword")
link("@keyword.function",    "Keyword")
link("@keyword.return",      "Keyword")
link("@keyword.operator",    "Operator")
link("@keyword.import",      "Include")
link("@keyword.directive",   "PreProc")
link("@keyword.modifier",    "Keyword")
link("@conditional",         "Conditional")
link("@repeat",              "Repeat")
link("@exception",           "Exception")
link("@comment",             "Comment")
link("@comment.documentation","Comment")
link("@label",               "Label")
link("@punctuation",         "Delimiter")
link("@punctuation.delimiter","Delimiter")
link("@punctuation.bracket",  "Delimiter")
link("@punctuation.special",  "Delimiter")
link("@attribute",           "PreProc")
link("@tag",                 "Keyword")
link("@tag.attribute",       "Identifier")
link("@tag.delimiter",       "Delimiter")

-- LSP Semantic Tokens
link("@lsp.type.class",         "Type")
link("@lsp.type.decorator",     "Function")
link("@lsp.type.enum",          "Type")
link("@lsp.type.enumMember",    "Constant")
link("@lsp.type.function",      "Function")
link("@lsp.type.interface",     "Type")
link("@lsp.type.macro",         "Macro")
link("@lsp.type.method",        "Function")
link("@lsp.type.namespace",     "Type")
link("@lsp.type.parameter",     "Identifier")
link("@lsp.type.property",      "Identifier")
link("@lsp.type.struct",        "Type")
link("@lsp.type.type",          "Type")
link("@lsp.type.typeParameter", "Type")
link("@lsp.type.variable",      "Identifier")
link("@lsp.mod.deprecated",     "DiagnosticDeprecated")

-- Markdown
hl("markdownH1",        { fg = colors.keyword, bold = true })
hl("markdownH2",        { fg = colors.keyword, bold = true })
hl("markdownH3",        { fg = colors.keyword, bold = true })
hl("markdownH4",        { fg = colors.keyword, bold = true })
hl("markdownH5",        { fg = colors.keyword, bold = true })
hl("markdownH6",        { fg = colors.keyword, bold = true })
hl("markdownCode",      { fg = colors.string })
hl("markdownCodeBlock", { fg = colors.string })
hl("markdownBold",      { bold = true })
hl("markdownItalic",    { italic = true })
hl("markdownLinkText",  { fg = colors.info, underline = true })
hl("markdownUrl",       { fg = colors.muted, underline = true })
hl("markdownListMarker",{ fg = colors.constant })
hl("markdownRule",      { fg = colors.border })
hl("markdownBlockquote",{ fg = colors.comment })

link("@markup.heading", "Title")
link("@markup.raw", "String")
link("@markup.link", "markdownLinkText")
link("@markup.link.url", "markdownUrl")
link("@markup.list", "markdownListMarker")
link("@markup.quote", "Comment")
link("@markup.strong", "markdownBold")
link("@markup.italic", "markdownItalic")

-- Git
hl("gitcommitHeader",      { fg = colors.keyword })
hl("gitcommitType",        { fg = colors.type })
hl("gitcommitSummary",     { fg = colors.fg })
hl("gitcommitBranch",      { fg = colors.func, bold = true })
hl("gitcommitDiscarded",   { fg = colors.error })
hl("gitcommitSelected",    { fg = colors.success })
hl("gitcommitUnmerged",    { fg = colors.warning })
hl("gitcommitUntracked",   { fg = colors.muted })

-- 6. Terminal Colors
vim.g.terminal_color_0  = colors.bg
vim.g.terminal_color_1  = colors.error
vim.g.terminal_color_2  = colors.success
vim.g.terminal_color_3  = colors.warning
vim.g.terminal_color_4  = colors.func
vim.g.terminal_color_5  = colors.keyword
vim.g.terminal_color_6  = colors.type
vim.g.terminal_color_7  = colors.fg
vim.g.terminal_color_8  = colors.border
vim.g.terminal_color_9  = colors.error
vim.g.terminal_color_10 = colors.success
vim.g.terminal_color_11 = colors.warning
vim.g.terminal_color_12 = colors.info
vim.g.terminal_color_13 = colors.preproc
vim.g.terminal_color_14 = colors.hint
vim.g.terminal_color_15 = colors.fg
