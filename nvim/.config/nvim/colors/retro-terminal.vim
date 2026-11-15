" ==============================================================================
" Vim Color File
" Name: retro-terminal
" Description: Enterprise C/C++ Dual-Pipeline Engine (TrueColor + ANSI Fallback)
" ==============================================================================

set background=dark
highlight clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name = "retro-terminal"

" ==============================================================================
" 1. CORE CANVAS & EDITOR UI
" ==============================================================================
hi Normal            ctermfg=White        ctermbg=Black        guifg=#c5c8c6 guibg=#000000 cterm=NONE gui=NONE
hi NonText           ctermfg=DarkGray     ctermbg=NONE         guifg=#5c5c5c guibg=NONE    cterm=NONE gui=NONE
hi EndOfBuffer       ctermfg=Black        ctermbg=Black        guifg=#000000 guibg=#000000 cterm=NONE gui=NONE
hi LineNr            ctermfg=DarkGray     ctermbg=Black        guifg=#5c5c5c guibg=#000000 cterm=NONE gui=NONE
hi CursorLineNr      ctermfg=Green        ctermbg=Black        guifg=#00af00 guibg=#000000 cterm=bold gui=bold
hi SignColumn        ctermfg=NONE         ctermbg=Black        guifg=NONE    guibg=#000000 cterm=NONE gui=NONE
hi Cursor            ctermfg=Black        ctermbg=White        guifg=#000000 guibg=#c5c8c6 cterm=NONE gui=NONE
hi CursorLine        ctermfg=NONE         ctermbg=DarkGray     guifg=NONE    guibg=#1c1c1c cterm=NONE gui=NONE
hi Search            ctermfg=White        ctermbg=LightBlue    guifg=#ffffff guibg=#5fd7ff cterm=NONE gui=NONE
hi IncSearch         ctermfg=Black        ctermbg=LightRed     guifg=#000000 guibg=#ff5f5f cterm=NONE gui=NONE
hi MatchParen        ctermfg=Black        ctermbg=LightMagenta guifg=#000000 guibg=#ff5fff cterm=bold gui=bold
hi StatusLine        ctermfg=White        ctermbg=DarkGray     guifg=#ffffff guibg=#3a3a3a cterm=NONE gui=NONE
hi StatusLineNC      ctermfg=DarkGray     ctermbg=Black        guifg=#5c5c5c guibg=#000000 cterm=NONE gui=NONE
hi Pmenu             ctermfg=White        ctermbg=DarkGray     guifg=#c5c8c6 guibg=#262626 cterm=NONE gui=NONE
hi PmenuSel          ctermfg=Black        ctermbg=LightBlue    guifg=#000000 guibg=#5fd7ff cterm=bold gui=bold
hi VertSplit         ctermfg=DarkGray     ctermbg=Black        guifg=#3a3a3a guibg=#000000 cterm=NONE gui=NONE
hi ErrorMsg          ctermfg=LightRed     ctermbg=NONE         guifg=#ff5f5f guibg=NONE    cterm=bold gui=bold
hi WarningMsg        ctermfg=Yellow       ctermbg=NONE         guifg=#d7d700 guibg=NONE    cterm=bold gui=bold
hi Error             ctermfg=LightRed     ctermbg=NONE         guifg=#ff5f5f guibg=NONE    cterm=NONE gui=NONE
hi Todo              ctermfg=Black        ctermbg=LightBlue    guifg=#000000 guibg=#5fd7ff cterm=bold gui=bold
hi CWordLight        ctermfg=Black        ctermbg=White        guifg=#000000 guibg=#c5c8c6 cterm=NONE gui=NONE
hi Directory         ctermfg=Blue         ctermbg=NONE         guifg=#005faf guibg=NONE    cterm=bold gui=bold
hi SpecialKey        ctermfg=DarkGray     ctermbg=Black        guifg=#5c5c5c guibg=#000000 cterm=NONE gui=NONE
hi WildMenu          ctermfg=Black        ctermbg=LightCyan    guifg=#000000 guibg=#5fffff cterm=bold gui=bold

" ==============================================================================
" 2. TABLINE ENGINE (Top-Mounted Buffers)
" ==============================================================================
hi TabLineFill       ctermfg=DarkGray     ctermbg=DarkGray     guifg=#262626 guibg=#262626 cterm=NONE gui=NONE
hi TabLine           ctermfg=White        ctermbg=DarkGray     guifg=#a8a8a8 guibg=#262626 cterm=NONE gui=NONE
hi TabLineSel        ctermfg=Black        ctermbg=White        guifg=#000000 guibg=#ffffff cterm=bold gui=bold

" ==============================================================================
" 3. C/C++ SYNTAX ENGINE (Native & Custom Regex Blocks)
" ==============================================================================
hi Comment           ctermfg=Green        ctermbg=NONE         guifg=#00af00 guibg=NONE cterm=NONE gui=NONE
hi String            ctermfg=Green        ctermbg=NONE         guifg=#00af00 guibg=NONE cterm=NONE gui=NONE
hi Identifier        ctermfg=White        ctermbg=NONE         guifg=#c5c8c6 guibg=NONE cterm=NONE gui=NONE
hi cCustomVar        ctermfg=White        ctermbg=NONE         guifg=#c5c8c6 guibg=NONE cterm=NONE gui=NONE
hi Type              ctermfg=LightBlue    ctermbg=NONE         guifg=#5fd7ff guibg=NONE cterm=NONE gui=NONE
hi cCustomType       ctermfg=LightBlue    ctermbg=NONE         guifg=#5fd7ff guibg=NONE cterm=NONE gui=NONE
hi StorageClass      ctermfg=LightBlue    ctermbg=NONE         guifg=#5fd7ff guibg=NONE cterm=NONE gui=NONE
hi Structure         ctermfg=LightBlue    ctermbg=NONE         guifg=#5fd7ff guibg=NONE cterm=NONE gui=NONE
hi Typedef           ctermfg=LightBlue    ctermbg=NONE         guifg=#5fd7ff guibg=NONE cterm=NONE gui=NONE
hi Constant          ctermfg=LightBlue    ctermbg=NONE         guifg=#5fd7ff guibg=NONE cterm=NONE gui=NONE
hi Number            ctermfg=LightBlue    ctermbg=NONE         guifg=#5fd7ff guibg=NONE cterm=NONE gui=NONE
hi Boolean           ctermfg=LightBlue    ctermbg=NONE         guifg=#5fd7ff guibg=NONE cterm=NONE gui=NONE
hi Float             ctermfg=LightBlue    ctermbg=NONE         guifg=#5fd7ff guibg=NONE cterm=NONE gui=NONE
hi PreProc           ctermfg=LightBlue    ctermbg=NONE         guifg=#5fd7ff guibg=NONE cterm=NONE gui=NONE
hi Macro             ctermfg=LightBlue    ctermbg=NONE         guifg=#5fd7ff guibg=NONE cterm=NONE gui=NONE
hi cCustomMacro      ctermfg=LightBlue    ctermbg=NONE         guifg=#5fd7ff guibg=NONE cterm=bold gui=bold
hi Function          ctermfg=Brown        ctermbg=NONE         guifg=#d78700 guibg=NONE cterm=NONE gui=NONE
hi cCustomFunc       ctermfg=Brown        ctermbg=NONE         guifg=#d78700 guibg=NONE cterm=NONE gui=NONE
hi Statement         ctermfg=LightMagenta ctermbg=NONE         guifg=#ff5fff guibg=NONE cterm=NONE gui=NONE
hi Conditional       ctermfg=LightMagenta ctermbg=NONE         guifg=#ff5fff guibg=NONE cterm=NONE gui=NONE
hi Repeat            ctermfg=LightMagenta ctermbg=NONE         guifg=#ff5fff guibg=NONE cterm=NONE gui=NONE
hi Keyword           ctermfg=LightMagenta ctermbg=NONE         guifg=#ff5fff guibg=NONE cterm=NONE gui=NONE
hi Delimiter         ctermfg=Red          ctermbg=NONE         guifg=#d70000 guibg=NONE cterm=NONE gui=NONE
hi Operator          ctermfg=Red          ctermbg=NONE         guifg=#d70000 guibg=NONE cterm=NONE gui=NONE
hi cCustomPointer    ctermfg=Red          ctermbg=NONE         guifg=#d70000 guibg=NONE cterm=NONE gui=NONE
hi cCustomOperator   ctermfg=Red          ctermbg=NONE         guifg=#d70000 guibg=NONE cterm=NONE gui=NONE

hi link ExtraWhitespace Error

" ==============================================================================
" 4. TELEMETRY ENGINE (Unified Statusline)
" ==============================================================================
hi StatusBase        ctermfg=LightCyan    ctermbg=Black        guifg=#5fffff guibg=#000000 cterm=NONE gui=NONE
hi StatusFile        ctermfg=White        ctermbg=Black        guifg=#ffffff guibg=#000000 cterm=bold gui=bold
hi StatusModified    ctermfg=LightRed     ctermbg=Black        guifg=#ff5f5f guibg=#000000 cterm=bold gui=bold
hi StatusGit         ctermfg=LightGreen   ctermbg=Black        guifg=#5fff5f guibg=#000000 cterm=NONE gui=NONE
hi StatusFunction    ctermfg=Yellow       ctermbg=Black        guifg=#d7d700 guibg=#000000 cterm=bold gui=bold

" Mode Indicators (Framed visual blocks)
hi StatusModeNormal  ctermfg=Black        ctermbg=White        guifg=#000000 guibg=#ffffff cterm=bold gui=bold
hi StatusModeInsert  ctermfg=Black        ctermbg=Green        guifg=#000000 guibg=#00af00 cterm=bold gui=bold
hi StatusModeVisual  ctermfg=Black        ctermbg=LightMagenta guifg=#000000 guibg=#ff5fff cterm=bold gui=bold
hi StatusModeReplace ctermfg=Black        ctermbg=LightRed     guifg=#000000 guibg=#ff5f5f cterm=bold gui=bold

" ==============================================================================
" 5. NATIVE ENGINE OVERRIDES (Netrw, Marks, Quickfix)
" ==============================================================================
hi SignatureMarkText ctermfg=Green        ctermbg=Black        guifg=#00af00 guibg=#000000 cterm=bold gui=bold
hi qfFileName        ctermfg=LightBlue    ctermbg=NONE         guifg=#5fd7ff guibg=NONE cterm=NONE gui=NONE
hi qfLineNr          ctermfg=Yellow       ctermbg=NONE         guifg=#d7d700 guibg=NONE cterm=NONE gui=NONE
hi qfSeparator       ctermfg=DarkGray     ctermbg=NONE         guifg=#5c5c5c guibg=NONE cterm=NONE gui=NONE
