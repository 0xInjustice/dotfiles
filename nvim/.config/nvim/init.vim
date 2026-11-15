" ==============================================================================
" CORE SETTINGS & TERMINAL PIPELINE
" ==============================================================================
let mapleader = " "

" MASTER BRIDGE: Restore the link between the Indent Engine and the Syntax Engine
syntax enable
filetype plugin indent on

" FORCE TERMINAL PIPELINE: Modern 24-bit color support & Fast Event Loop
set termguicolors
set background=dark
set updatetime=250
set clipboard=unnamedplus
set hlsearch
set incsearch
set smartcase
set ignorecase
set showmatch
set number
set relativenumber
set ruler
set showcmd
set nowrapscan
set cursorline
set nosmartindent
set copyindent
set shiftwidth=4
set tabstop=4
set expandtab
set omnifunc=syntaxcomplete#Complete
set formatoptions=tcqrn1
set foldmethod=manual
set foldnestmax=16
set foldlevelstart=99

set wildmenu
set wildmode=list:longest,full

" Server / Performance specific
set nobackup
set nowritebackup
set noswapfile
set history=1000

" ==============================================================================
" PLUGINS (The Minimal Core)
" ==============================================================================
call plug#begin('~/.local/share/nvim/plugged')
    Plug 'tpope/vim-surround'
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'justinmk/vim-sneak'
    Plug 'luochen1990/rainbow'
call plug#end()

" TRIGGER COLOR CANVAS (Silent fallback for fresh environments)
silent! colorscheme retro-terminal

" ==============================================================================
" REMAINING PLUGIN CONFIGURATIONS
" ==============================================================================
" --- Gutentags ---
let g:gutentags_project_root = ['.git', '.svn', 'Makefile', 'CMakeLists.txt']
let g:gutentags_cache_dir = expand('~/.local/share/nvim/tags')
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0
set tags=./tags;,tags;

" --- Sneak ---
let g:sneak#label = 1
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

" --- Rainbow ---
let g:rainbow_active = 1

" ==============================================================================
" NATIVE ENGINE 1: DIRECTORY EXPLORER (Replaces NERDTree)
" ==============================================================================
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
let g:netrw_keepdir = 0
let g:netrw_sort_sequence = '[\/]$,*'
let g:netrw_list_hide = '^\.git\/$,\.o$,\.out$,\.swp$'

nnoremap <leader>ee :Lexplore<CR>

" ==============================================================================
" NATIVE ENGINE 2: RECURSIVE FILE LOCATOR (Replaces CtrlP)
" ==============================================================================
set path+=**
set wildignore+=*/.git/*,*/.svn/*,*/build/*,*/out/*,*.o,*.obj,*.a,*.so,*.exe
nnoremap <leader>F :find *<Left>
nnoremap <leader>B :b *<Left>

" ==============================================================================
" NATIVE ENGINE 3: COMMENT TOGGLE (Replaces vim-commentary)
" ==============================================================================
function! NativeCommentToggle() range
    let l:save_cursor = getpos(".")
    let l:save_search = @/
    for l:line_num in range(a:firstline, a:lastline)
        let l:line_text = getline(l:line_num)
        if l:line_text =~# '^\s*\/\/'
            execute l:line_num . 's/^\(\s*\)\/\/\s*/\1/e'
        else
            execute l:line_num . 's/^\(\s*\)/\1\/\/ /e'
        endif
    endfor
    let @/ = l:save_search
    call setpos('.', l:save_cursor)
endfunction
nnoremap <silent> gc :set opfunc=NativeCommentToggle<CR>g@
vnoremap <silent> gc :call NativeCommentToggle()<CR>

" ==============================================================================
" NATIVE ENGINE 4: ALTERNATE C/C++ FILE (Replaces a.vim)
" ==============================================================================
function! NativeAlternateFile(open_in_split)
    let l:root = expand('%:p:r') 
    let l:ext = tolower(expand('%:e'))
    let l:target = ""
    if l:ext ==# 'c' || l:ext ==# 'cpp' || l:ext ==# 'cc'
        let l:target = l:root . '.h'
        if !filereadable(l:target) | let l:target = l:root . '.hpp' | endif
    elseif l:ext ==# 'h' || l:ext ==# 'hpp'
        let l:target = l:root . '.cpp'
        if !filereadable(l:target) | let l:target = l:root . '.c' | endif
    else
        redraw! | echo "Not a recognized C/C++ file."
        return
    endif
    if filereadable(l:target)
        if a:open_in_split == 1
            execute 'vsplit ' . fnameescape(l:target)
        else
            execute 'edit ' . fnameescape(l:target)
        endif
    else
        redraw! | echo "Alternate file not found: " . fnamemodify(l:target, ':t')
    endif
endfunction
nnoremap <leader>a :call NativeAlternateFile(0)<CR>
nnoremap <leader>av :call NativeAlternateFile(1)<CR>

" ==============================================================================
" NATIVE ENGINE 5: AUTO-PAIRS (Replaces auto-pairs plugin)
" ==============================================================================
inoremap " ""<Left>
inoremap ' ''<Left>
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>
inoremap <expr> <CR> getline('.')[col('.')-2:col('.')-1] ==# '{}' ? "\<CR>\<Esc>O" : "\<CR>"

" ==============================================================================
" NATIVE ENGINE 6: ASYNCHRONOUS GIT TELEMETRY (Replaces vim-fugitive)
" ==============================================================================
function! NativeGitDiff()
    let l:file_rel = expand('%')
    if empty(l:file_rel) | return | endif
    diffthis
    leftabove vnew
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
    let l:cmd = 'git show HEAD:' . shellescape(l:file_rel)
    let l:output = systemlist(l:cmd)
    call setline(1, l:output)
    setlocal nomodifiable filetype=c
    diffthis
endfunction

function! NativeGitStatus()
    botright 15split term://git status
    startinsert
endfunction

nnoremap <leader>gd :call NativeGitDiff()<CR>
nnoremap <leader>gs :call NativeGitStatus()<CR>
nnoremap <leader>gx :diffoff! <bar> q<CR>

" ==============================================================================
" NATIVE ENGINE 7: STRUCTURAL MATRIX ALIGNMENT (Replaces vim-easy-align)
" ==============================================================================
function! NativeAlign(delimiter) range
    let l:lines = []
    let l:max_col = 0
    for l:lnum in range(a:firstline, a:lastline)
        let l:line = getline(l:lnum)
        let l:pos = stridx(l:line, a:delimiter)
        if l:pos != -1
            let l:left_part = substitute(strpart(l:line, 0, l:pos), '\s\+$', '', '')
            let l:right_part = substitute(strpart(l:line, l:pos + 1), '^\s\+', '', '')
            let l:col = len(l:left_part)
            if l:col > l:max_col | let l:max_col = l:col | endif
            call add(l:lines, {'num': l:lnum, 'left': l:left_part, 'right': l:right_part})
        endif
    endfor
    for l:item in l:lines
        let l:padding = repeat(' ', l:max_col - len(l:item.left) + 1)
        let l:new_line = l:item.left . l:padding . a:delimiter . ' ' . l:item.right
        call setline(l:item.num, l:new_line)
    endfor
    redraw! | echo "Matrix Aligned to: '" . a:delimiter . "'"
endfunction
vnoremap <silent> <leader>a= :call NativeAlign('=')<CR>
vnoremap <silent> <leader>a: :call NativeAlign(':')<CR>

" ==============================================================================
" NATIVE ENGINE 8: VISUAL MARK TRACKER (Replaces vim-signature)
" ==============================================================================
for s:char_code in range(97, 122) + range(65, 90)
    let s:char = nr2char(s:char_code)
    execute 'sign define NativeMark_' . s:char . ' text=' . s:char . ' texthl=SignatureMarkText'
endfor

function! UpdateNativeMarks()
    execute 'sign unplace * buffer=' . bufnr('%')
    let l:marks = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    for l:i in range(len(l:marks))
        let l:m = l:marks[l:i]
        let l:pos = getpos("'" . l:m)
        let l:mark_buf = (l:pos[0] == 0) ? bufnr('%') : l:pos[0]
        if l:mark_buf == bufnr('%') && l:pos[1] > 0
            execute 'sign place ' . (1000 + l:i) . ' line=' . l:pos[1] . ' name=NativeMark_' . l:m . ' buffer=' . bufnr('%')
        endif
    endfor
endfunction

augroup NativeMarkEngine
    autocmd!
    autocmd BufEnter,BufWritePost,CursorHold * call UpdateNativeMarks()
augroup END
nnoremap <silent> m :set opfunc=TriggerNativeMark<CR>g@
function! TriggerNativeMark(type)
    call UpdateNativeMarks()
endfunction

" ==============================================================================
" NATIVE ENGINE 9: CHRONOLOGY MATRIX (Replaces undotree)
" ==============================================================================
function! NativeTimeTravel()
    let l:raw_list = execute('undolist')
    if l:raw_list =~# 'Nothing to undo'
        redraw! | echo "Chronology Empty: No history logged for this buffer."
        return
    endif
    redraw!
    echohl Statement | echo "--- STRUCTURAL TIMELINE ---" | echohl None
    echo l:raw_list
    echo "---------------------------"
    let l:target = input("Enter Save State ID to load (or press Enter to abort): ")
    if empty(l:target) || l:target !~# '^\d\+$'
        redraw! | echo "Time Travel Aborted."
        return
    endif
    execute 'undo ' . l:target
    redraw! | echo "Reverted buffer state to Node ID: " . l:target
endfunction
nnoremap <silent> <leader>u :call NativeTimeTravel()<CR>

" ==============================================================================
" NATIVE ENGINE 10: C/C++ STRUCTURAL LINTER (Replaces ALE)
" ==============================================================================
function! NativeLintEngine()
    let l:file = expand('%:p')
    if empty(l:file) || !filereadable(l:file) | return | endif
    let l:ext = expand('%:e')
    let l:cmd = ''
    if l:ext ==# 'c'
        let l:cmd = 'gcc -fsyntax-only -Wall ' . shellescape(l:file) . ' 2>&1'
    elseif l:ext =~# '^\(cpp\|cc\|hpp\|h\)$'
        let l:cmd = 'g++ -fsyntax-only -Wall -std=c++11 ' . shellescape(l:file) . ' 2>&1'
    else
        return
    endif
    lexpr []
    let l:output = system(l:cmd)
    if v:shell_error != 0 || l:output =~? 'warning:'
        let l:save_efm = &errorformat
        set errorformat=%f:%l:%c:\ %t%*[^:]:\ %m,%f:%l:\ %t%*[^:]:\ %m
        lexpr l:output
        let &errorformat = l:save_efm
        lwindow 10
        redraw! | echohl ErrorMsg | echo "[LINT ENGINE]: Structural Anomalies Detected." | echohl None
    else
        lclose
        redraw! | echo "[LINT ENGINE]: Code Structure Verified (0 Errors)."
    endif
endfunction
augroup NativeLinting
    autocmd!
    autocmd BufWritePost *.c,*.cpp,*.h,*.hpp call NativeLintEngine()
augroup END
nnoremap <silent> [e :lprevious<CR>
nnoremap <silent> ]e :lnext<CR>

" ==============================================================================
" NATIVE ENGINE 11: C/C++ COMPILER & EXECUTION PIPELINE
" ==============================================================================
function! NativeCompileAndRun()
    silent! update
    let l:filename = expand('%')
    let l:ext = expand('%:e')
    let l:out_bin = expand('%:r') . '.out'
    let l:cmd = ''
    if l:ext ==# 'c'
        let l:cmd = 'gcc ' . shellescape(l:filename) . ' -o ' . shellescape(l:out_bin)
    elseif l:ext ==# 'cpp' || l:ext ==# 'cc'
        let l:cmd = 'g++ ' . shellescape(l:filename) . ' -o ' . shellescape(l:out_bin)
    else
        redraw! | echo "Execution Aborted: Buffer is not a C or C++ file."
        return
    endif
    let l:full_pipeline = l:cmd . ' && ./' . shellescape(l:out_bin)
    execute 'botright 15split term://bash -c "' . l:full_pipeline . '; echo; echo \[PROCESS TERMINATED\]; read -p \"Press Enter to close...\""'
    startinsert
endfunction
nnoremap <silent> <leader>rr :call NativeCompileAndRun()<CR>

" ==============================================================================
" NATIVE ENGINE 12: BULLETPROOF PROJECT SEARCH (Color-Shielded & Aligned)
" ==============================================================================
function! SmartProjectSearch()
    let l:word = expand("<cword>")
    if empty(l:word) | return | endif
    cexpr []
    redraw! | echo "Scanning project via internal vimgrep for '" . l:word . "'..."
    let l:save_ei = &eventignore
    set eventignore=all
    try
        execute 'silent! vimgrep /\<' . l:word . '\>/j **/*.c **/*.cpp **/*.h **/*.hpp'
    catch /^Vim\%((\a\+)\)\=:E480/
        let &eventignore = l:save_ei
        redraw! | echo "[SEARCH ENGINE]: No matches found for '" . l:word . "'."
        cclose
        return
    finally
        let &eventignore = l:save_ei
    endtry
    
    let l:qf_list = getqflist()
    for l:item in l:qf_list
        let l:item.text = substitute(l:item.text, '^\s\+', '', '')
    endfor
    call setqflist(l:qf_list, 'r')
    copen
    silent! call clearmatches()
    call matchadd('Search', '\<' . l:word . '\>')
    redraw! | echo "[SEARCH ENGINE]: Scan complete. Results structurally aligned."
endfunction
nnoremap <leader>fw :call SmartProjectSearch()<CR>

" ==============================================================================
" GENERAL MAPPINGS
" ==============================================================================
nnoremap <leader>nh :nohlsearch<CR>
nnoremap n nzzzv
nnoremap N Nzzzv

" Window & Buffer Management
nnoremap <leader>sv :vsplit<CR>
nnoremap <leader>sh :split<CR>
nnoremap <leader>sx :close<CR>
nnoremap <leader>se <C-w>=
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

nnoremap <leader>bn :bn<CR>
nnoremap <leader>bp :call PurgeHiddenBuffers()<CR>
nnoremap <leader>bb :enew<CR>
nnoremap <leader>bd :bd<CR>
nnoremap <leader>ba :ba<CR>
nnoremap <leader>bw :wa<CR>
nnoremap <leader>bq :xa<CR>
nnoremap <leader>bl :ls<CR>:b<Space>

" Tab Management
nnoremap <leader>to :tabe .<CR>
nnoremap <leader>tx :tabclose<CR>
nnoremap <leader>tn :tabn<CR>
nnoremap <leader>tp :tabp<CR>
nnoremap <leader>tf :tabnew %<CR>

nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt
nnoremap <leader>6 6gt
nnoremap <leader>7 7gt
nnoremap <leader>8 8gt
nnoremap <leader>9 9gt

" Folding
nnoremap <leader>fa za
nnoremap <leader>fm zM
nnoremap <leader>fo zR

" Utilities
nnoremap <leader>ff :vimgrep // **/*<Left><Left><Left><Left><Left><Left>
nnoremap <leader>fl :execute "vimgrep /" . escape(@/, '/') . "/j %" <Bar> cw<CR>
nnoremap <leader>cn :cnext<CR>
nnoremap <leader>cp :cprev<CR>
nnoremap <leader>co :copen<CR>
nnoremap <leader>cl :cclose<CR>
nnoremap [I [I:let nr = input("Which one: ")<Bar>exe "normal " . nr . "[\t"<CR>
nnoremap <leader>d "_d
vnoremap <leader>d "_d
nnoremap <leader>ww :w<CR>
nnoremap <leader>wq :wqa<CR>
nnoremap <leader><leader>q :q<CR>
nnoremap <leader>qq :qa!<CR>
nnoremap <leader>'' :reg<CR>

" ==============================================================================
" ADVANCED TOOLS MAPPINGS
" ==============================================================================
nnoremap <leader>st :split term://bash<CR>resize 15<CR>
tnoremap <Esc> <C-\><C-n>

" --- The Tag Stack Engine ---
nnoremap <leader>j <C-]>
nnoremap <leader>k <C-t>
nnoremap <leader>sj :vsplit<CR>:exec("tag " . expand('<cword>'))<CR>:colorscheme retro-terminal<CR>
nnoremap <leader>sk :execute "tab tjump " . expand('<cword>')<CR>:colorscheme retro-terminal<CR>
nnoremap <A-j> <C-]>
nnoremap <A-k> <C-t>
nnoremap ]t :tnext<CR>
nnoremap [t :tprev<CR>

inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"

" ==============================================================================
" THE MECHANICS OF MEMORY & SCALE
" ==============================================================================
if has('persistent_undo')
    let target_path = expand('~/.local/share/nvim/undo')
    if !isdirectory(target_path)
        call mkdir(target_path, "p", 0700)
    endif
    let &undodir = target_path
    set undofile
endif

let shada_path = expand('~/.local/share/nvim/shada')
if !isdirectory(shada_path)
    call mkdir(shada_path, "p", 0700)
endif
set shada='1000,<50,s10,h

augroup RestoreCursor
    autocmd!
    autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   execute "normal! g`\"" |
        \ endif
augroup END

augroup LargeFileShield
    autocmd!
    autocmd BufReadPre * if getfsize(expand("<afile>")) > 50000000 |
        \ setlocal noswapfile noundofile |
        \ setlocal undolevels=-1 |
        \ let b:rainbow_active = 0 |
        \ syntax off |
        \ echohl WarningMsg | echo "BLAST SHIELD ACTIVE: 50MB+ File Detected. Heavy engines disabled." | echohl None |
        \ endif
augroup END

augroup AutoSaveGroup
    autocmd!
    autocmd BufLeave,FocusLost * if &buftype == '' && &modifiable | silent! wall | endif
    autocmd TextChanged,InsertLeave * if &buftype == '' && &modifiable | silent! update | endif
augroup END

highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
nnoremap <leader>W :%s/\s\+$//e<CR>

" ==============================================================================
" CONSOLIDATED C/C++ STATIC REGEX ENGINE
" ==============================================================================
function! ReinforceCustomSyntax()
    syntax sync minlines=2000
    syntax match cCustomMacro '\<[A-Z][A-Z0-9_]*\>'
    syntax match cCustomType '\<ts[a-zA-Z0-9_]\+\>'
    syntax match cCustomFunc '\<\w\+\>\s*(\@='
    syntax match cCustomVar '\<[a-z][A-Z][a-zA-Z0-9_]*\>'
    syntax match cCustomPointer '\(->\|\*\|&\)'
    syntax match cCustomOperator '\(&&\|||\|==\|!=\|<\|>\|<=\|>=\|++\|--\)'
endfunction

augroup CppStaticRegexEngine
    autocmd!
    autocmd FileType c,cpp,java setlocal expandtab tabstop=5 shiftwidth=5 softtabstop=5
                \ | setlocal cindent nosmartindent
                \ | setlocal comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
                \ | setlocal cinkeys=0{,0},0),:,0#,!^F,o,O,e
                \ | setlocal cinoptions=>5,{0,e0,n5,+5,f0,:0,=5,(0,u0,w1
    autocmd Syntax c,cpp call ReinforceCustomSyntax()
    autocmd FileType c,cpp if empty(&syntax) | syntax enable | endif
    autocmd BufReadPost *.c,*.cpp,*.cc,*.h,*.hpp if empty(&syntax) | syntax enable | endif
augroup END

" ==============================================================================
" THE MML ENTERPRISE INDENTATION ENGINE (With Syntax Shield)
" ==============================================================================
function! ApplyMmlIndent() range
    let l:save_sw = &l:shiftwidth
    let l:save_ts = &l:tabstop
    let l:save_sts = &l:softtabstop
    let l:save_cino = &l:cinoptions
    let l:save_cind = &l:cindent
    let l:masked_coords = []
    
    for l:lnum in range(a:firstline, a:lastline)
        let l:line = getline(l:lnum)
        if l:line !~# '[{}]' | continue | endif
        
        let l:col = 1
        let l:len = strlen(l:line)
        while l:col <= l:len
            let l:char = strpart(l:line, l:col - 1, 1)
            if l:char ==# '{' || l:char ==# '}'
                let l:syn_id = synID(l:lnum, l:col, 1)
                let l:syn_name = synIDattr(l:syn_id, "name")
                if l:syn_name =~? 'comment' || l:syn_name =~? 'string'
                    call add(l:masked_coords, {'line': l:lnum, 'col': l:col, 'char': l:char})
                    let l:line = strpart(l:line, 0, l:col - 1) . 'X' . strpart(l:line, l:col)
                    call setline(l:lnum, l:line)
                endif
            endif
            let l:col += 1
        endwhile
    endfor

    setlocal cindent
    setlocal shiftwidth=5 tabstop=5 softtabstop=5
    setlocal cinoptions=>5,{5,+5,:5,=5,l1,b1,g0,h5,(0
    execute a:firstline . ',' . a:lastline . 'normal! =='

    for l:mask in l:masked_coords
        let l:line = getline(l:mask.line)
        let l:line = strpart(l:line, 0, l:mask.col - 1) . l:mask.char . strpart(l:line, l:mask.col)
        call setline(l:mask.line, l:line)
    endfor

    let &l:shiftwidth = l:save_sw
    let &l:tabstop = l:save_ts
    let &l:softtabstop = l:save_sts
    let &l:cinoptions = l:save_cino
    let &l:cindent = l:save_cind

    redraw!
    echo "MML Enterprise Format Applied (" . (a:lastline - a:firstline + 1) . " lines)"
endfunction
nnoremap <leader>e= :%call ApplyMmlIndent()<CR>
vnoremap <leader>e= :call ApplyMmlIndent()<CR>

" ==============================================================================
" CUSTOM TOOLS: SUBTLE WORD HIGHLIGHTING ENGINE
" ==============================================================================
function! UpdateSubtleHighlight()
    if get(w:, 'subtle_highlight_active', 1)
        execute 'silent! match CWordLight /\V\<' . escape(expand('<cword>'), '/\') . '\>/'
    endif
endfunction

function! ToggleSubtleWordHighlight()
    if get(w:, 'subtle_highlight_active', 1)
        let w:subtle_highlight_active = 0
        match none
        echo "Subtle Word Highlight: OFF"
    else
        let w:subtle_highlight_active = 1
        call UpdateSubtleHighlight()
        echo "Subtle Word Highlight: ON"
    endif
endfunction

augroup SubtleHighlightGroup
    autocmd!
    autocmd BufEnter,BufWinEnter,CursorMoved * call UpdateSubtleHighlight()
augroup END
nnoremap <leader>hh :call ToggleSubtleWordHighlight()<CR>

" ==============================================================================
" CUSTOM TOOLS: ZOOM & SESSIONS
" ==============================================================================
function! ToggleMaximize()
    if exists("t:zoomed") && t:zoomed
        tabclose
    else
        tab split
        let t:zoomed = 1
    endif
endfunction
nnoremap <leader>so :call ToggleMaximize()<CR>

function! SaveTaggedSession()
    let l:session_dir = expand('~/.config/nvim/sessions/')
    let l:display_name = fnamemodify(getcwd(), ':t')
    let l:project_id = substitute(getcwd(), '/', '_', 'g')
    let l:glob_pattern = l:session_dir . l:project_id . '_*.vim'
    let l:sessions = split(glob(l:glob_pattern), '\n')
    let l:tag = ""

    if !empty(l:sessions)
        redraw!
        echo "Save Session for '" . l:display_name . "':"
        echo "0: [WARNING: Delete all sessions for this directory]"
        let l:i = 1
        for l:s in l:sessions
            let l:filename = fnamemodify(l:s, ':t:r')
            echo l:i . ": Overwrite [" . split(l:filename, '_')[-1] . "]"
            let l:i += 1
        endfor
        echo l:i . ": [Create a NEW session tag]"
        let l:choice = input("Enter number: ")
        if l:choice == '0'
            for l:s in l:sessions | call delete(l:s) | endfor
            redraw! | echo "Deleted all sessions for " . l:display_name | return
        elseif l:choice =~ '^\d\+$' && l:choice > 0 && l:choice < l:i
            let l:filename = fnamemodify(l:sessions[l:choice - 1], ':t:r')
            let l:tag = split(l:filename, '_')[-1]
        elseif l:choice == l:i
            let l:tag = input("Enter NEW session tag (leave blank for 'main'): ")
        else
            redraw! | echo "Canceled." | return
        endif
    else
        let l:tag = input("Enter session tag (leave blank for 'main'): ")
    endif
    if l:tag == "" | let l:tag = "main" | endif
    let l:session_file = l:session_dir . l:project_id . '_' . l:tag . '.vim'
    if filereadable(l:session_file) | call delete(l:session_file) | endif
    execute 'mksession! ' . fnameescape(l:session_file)
    redraw! | echo "Saved Session: " . l:display_name . " [" . l:tag . "]"
endfunction

function! LoadTaggedSession()
    let l:session_dir = expand('~/.config/nvim/sessions/')
    let l:display_name = fnamemodify(getcwd(), ':t')
    let l:project_id = substitute(getcwd(), '/', '_', 'g')
    let l:glob_pattern = l:session_dir . l:project_id . '_*.vim'
    let l:sessions = split(glob(l:glob_pattern), '\n')

    if empty(l:sessions)
        echo "No sessions found for this directory."
        return
    endif
    redraw!
    echo "Load Session for '" . l:display_name . "':"
    echo "0: [WARNING: Delete all sessions for this directory]"
    let l:i = 1
    for l:s in l:sessions
        let l:filename = fnamemodify(l:s, ':t:r')
        echo l:i . ": Load [" . split(l:filename, '_')[-1] . "]"
        let l:i += 1
    endfor
    let l:choice = input("Enter number to load/delete: ")
    if l:choice == '0'
        for l:s in l:sessions | call delete(l:s) | endfor
        redraw! | echo "Deleted all sessions for " . l:display_name | return
    elseif l:choice =~ '^\d\+$' && l:choice > 0 && l:choice <= len(l:sessions)
        let l:idx = l:choice - 1
        execute 'source ' . fnameescape(l:sessions[l:idx])
        let l:filename = fnamemodify(l:sessions[l:idx], ':t:r')
        let l:tag = split(l:filename, '_')[-1]
        redraw! | echo "Loaded workspace: " . l:display_name . " [" . l:tag . "]"
    else
        redraw! | echo "Canceled."
    endif
endfunction

nnoremap <leader>ms :call SaveTaggedSession()<CR>
nnoremap <leader>ml :call LoadTaggedSession()<CR>

" ==============================================================================
" ASYNCHRONOUS SYMBOL BAR
" ==============================================================================
highlight default link NativeSymFunc Statement
highlight default link NativeSymVar Type
highlight default link NativeSymHdr Special

function! s:JumpToSymbol()
    let l:line = getline('.')
    let l:lnum = matchstr(l:line, '\(L:\)\@<=\d\+')
    if empty(l:lnum) | return | endif
    wincmd p
    execute l:lnum
    normal! zz
endfunction

function! PopulateSymbolBarAsync(job_id, data, event)
    let l:bufnr = bufnr("NativeSymbolBar")
    let l:target_win = bufwinnr(l:bufnr)
    if l:target_win == -1 | return | endif

    let l:output = [" [ SYMBOLS ]"]
    for l:line in a:data
        if empty(l:line) | continue | endif
        let l:parts = split(l:line, '\v\s+')
        if len(l:parts) >= 3
            let l:icon = (l:parts[1] =~# 'f') ? 'ƒ' : '•'
            call add(l:output, printf("  %s  %s  (L:%s)", l:icon, l:parts[0], l:parts[2]))
        endif
    endfor

    let l:current_win = winnr()
    noautocmd execute l:target_win . 'wincmd w'
    setlocal modifiable
    silent! %delete _
    call setline(1, l:output)
    setlocal nomodifiable
    noautocmd execute l:current_win . 'wincmd w'
endfunction

function! NativeToggleSymbolBar()
    let l:bufname = "NativeSymbolBar"
    let l:winnr = bufwinnr(l:bufname)

    if l:winnr != -1
        execute l:winnr . 'wincmd c'
        return
    endif
    let l:file = expand('%:p')
    if empty(l:file) | return | endif

    execute 'botright vertical split ' . l:bufname
    vertical resize 45
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap cursorline

    syntax match SymbolIconFunc /ƒ/
    syntax match SymbolIconVar /•/
    syntax match SymbolName /\%(ƒ\|•\)\s\+\zs\w\+/
    syntax match SymbolLineNum /L:\d\+/ contained
    syntax match SymbolLineWrapper /(L:\d\+)/ contains=SymbolLineNum
    highlight default link SymbolIconFunc Statement
    highlight default link SymbolIconVar Type
    highlight default link SymbolName Identifier
    highlight default link SymbolLineWrapper Comment
    highlight default link SymbolLineNum Number

    call setline(1, " [ SYMBOLS LOADING... ]")
    setlocal nomodifiable
    nnoremap <buffer> <CR> :call <SID>JumpToSymbol()<CR>
    wincmd p

    let l:cmd = ['ctags', '-x', '--c-kinds=+pf', '--fields=+i', l:file]
    call jobstart(l:cmd, {
        \ 'on_stdout': function('PopulateSymbolBarAsync'),
        \ 'stdout_buffered': 1
        \ })
endfunction
nnoremap <silent> <Leader>tt :call NativeToggleSymbolBar()<CR>

" ==============================================================================
" THE CORE DATA LAYER: ASYNC CTAGS CACHE ENGINE (Thread-Safe & Zero-Lag)
" ==============================================================================
function! ParseCtagsAsync(job_id, data, event) dict
    if a:event == 'stdout'
        for l:entry in a:data
            if empty(l:entry) | continue | endif
            let l:parts = split(l:entry, '\v\s+')
            if len(l:parts) >= 3 && l:parts[1] ==# 'function'
                call add(self.temp_cache, {'name': l:parts[0], 'line': str2nr(l:parts[2])})
            endif
        endfor
    elseif a:event == 'exit'
        call setbufvar(self.buf_id, 'ctags_cache', self.temp_cache)
        execute 'silent! redrawstatus'
        execute 'silent! redrawtabline'
    endif
endfunction

function! UpdateFileCtagsCache()
    let l:file = expand('%:p')
    if empty(l:file) | return | endif
    let l:cmd = ['ctags', '-x', '--c-kinds=f', '--fields=+i', l:file]
    call jobstart(l:cmd, {
        \ 'buf_id': bufnr('%'),
        \ 'temp_cache': [],
        \ 'on_stdout': function('ParseCtagsAsync'),
        \ 'on_exit': function('ParseCtagsAsync'),
        \ 'stdout_buffered': 1
        \ })
endfunction

" The $O(N)$ Pure Memory Lookup used by both UI Panels
function! GetCurrentFunctionScope()
    let l:cache = get(b:, 'ctags_cache', [])
    if empty(l:cache) | return '' | endif

    let l:curr_line = line('.')
    let l:current_func = ''
    let l:closest_line = 0

    for l:item in l:cache
        if l:item.line <= l:curr_line && l:item.line >= l:closest_line
            let l:current_func = l:item.name
            let l:closest_line = l:item.line
        endif
    endfor

    return !empty(l:current_func) ? ' { ' . l:current_func . ' } ' : ''
endfunction

augroup CtagsFileCache
    autocmd!
    autocmd BufEnter,BufWritePost *.c,*.cpp,*.h,*.hpp call UpdateFileCtagsCache()
augroup END

" ==============================================================================
" THE UI LAYER: TABLINE (Enterprise Command Deck) & STATUSLINE
" ==============================================================================
let s:neovim_start_time = reltime()
function! GetSessionUptime()
    let l:sec = reltimefloat(reltime(s:neovim_start_time))
    let l:h = float2nr(l:sec / 3600)
    let l:m = float2nr(fmod(l:sec / 60, 60))
    return printf("%02d:%02d", l:h, l:m)
endfunction

function! TopTelemetryEngine()
    let l:s = ''
    
    " Navigation Matrix
    for i in range(1, tabpagenr('$'))
        let l:buflist = tabpagebuflist(i)
        let l:winnr = tabpagewinnr(i)
        let l:bufnr = l:buflist[l:winnr - 1]
        let l:file = bufname(l:bufnr)
        let l:filename = empty(l:file) ? '[No Name]' : fnamemodify(l:file, ':t')
        
        if i == tabpagenr()
            let l:s .= '%#TabLineSel#[ ' . i . ':' . l:filename . ' ]%*'
        else
            let l:s .= '%#TabLine# ' . i . ':' . l:filename . ' %*'
        endif
        let l:s .= '%#TabLineFill#│'
    endfor

    " Elastic Spring
    let l:s .= '%=%#TabLineFill#'

    " Telemetry Stream
    let l:git_telemetry = ''
    if exists('*FugitiveHead')
        let l:head = FugitiveHead()
        if l:head !=# ''
            let l:git_telemetry = '%#StatusGit#[git:' . l:head . '] '
        endif
    endif

    let l:tagbar_telemetry = ''
    let l:current_func = GetCurrentFunctionScope()
    if !empty(l:current_func)
        let l:tagbar_telemetry = '%#StatusFunction#' . l:current_func . ' '
    endif

    let l:uptime_telemetry = '%#StatusBase#[up: ' . GetSessionUptime() . ']'

    let l:s .= l:git_telemetry . l:tagbar_telemetry . l:uptime_telemetry . ' '
    return l:s
endfunction
set tabline=%!TopTelemetryEngine()

set noshowmode
function! NativeTelemetryEngine()
    let l:current_mode = mode()
    if l:current_mode ==# 'i'
        let l:mode_color = '%#StatusModeInsert#'
        let l:mode_text  = ' INSERT '
    elseif l:current_mode ==# 'v' || l:current_mode ==# 'V' || l:current_mode ==# "\<C-V>"
        let l:mode_color = '%#StatusModeVisual#'
        let l:mode_text  = ' VISUAL '
    elseif l:current_mode ==# 'R'
        let l:mode_color = '%#StatusModeReplace#'
        let l:mode_text  = ' REPLACE '
    else
        let l:mode_color = '%#StatusModeNormal#'
        let l:mode_text  = ' NORMAL '
    endif

    " Build Left Side
    let l:status = l:mode_color . '[' . l:mode_text . ']'
    let l:status .= '%#StatusBase# [file: %f'
    let l:status .= '%#StatusModified#%m%#StatusBase#] '

    " Center Spring & Scope
    let l:status .= '%='
    let l:status .= '%#StatusFunction#' . GetCurrentFunctionScope()
    let l:status .= '%='

    " Build Right Side
    let l:status .= '%#StatusBase#[%Y] '
    let l:status .= '[%{&fileformat}:%{&fileencoding}] '
    let l:status .= '[%l:%c %p%%]'
    return l:status
endfunction
set statusline=%!NativeTelemetryEngine()

" ==============================================================================
" TACTILE YANK FEEDBACK (Native Lua Bridge)
" ==============================================================================
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=200})
augroup END

" ==============================================================================
" BUFFER MEMORY PURGE (RAM Flush)
" ==============================================================================
function! PurgeHiddenBuffers()
    let l:visible_bufs = {}
    for l:w in range(1, winnr('$'))
        let l:visible_bufs[winbufnr(l:w)] = 1
    endfor
    let l:purged = 0
    for l:b in range(1, bufnr('$'))
        if bufexists(l:b) && !has_key(l:visible_bufs, l:b) && getbufvar(l:b, '&modified') == 0 && getbufvar(l:b, '&buftype') !=# 'terminal'
            execute 'bwipeout ' . l:b
            let l:purged += 1
        endif
    endfor
    redraw! | echo "System flushed: Purged " . l:purged . " background buffers from RAM."
endfunction

" ==============================================================================
" SUB-PANE PHYSICS ENGINE
" ==============================================================================
nnoremap <silent> <C-Right> :vertical resize +5<CR>
nnoremap <silent> <C-Left> :vertical resize -5<CR>
nnoremap <silent> <C-Up> :resize +2<CR>
nnoremap <silent> <C-Down> :resize -2<CR>

" ==============================================================================
" NATIVE BOILERPLATE ENGINE
" ==============================================================================
let g:cpp_snippets = {
    \ 'fori': "for (int i = 0; i < <++>; ++i) {\<CR><++>\<CR>}",
    \ 'class': "class <++> {\<CR>public:\<CR><++>();\<CR>~<++>();\<CR>\<CR>private:\<CR><++>\<CR>};",
    \ 'cout': "std::cout << <++> << std::endl;",
    \ 'main': "int main(int argc, char* argv[]) {\<CR><++>\<CR>return 0;\<CR>}",
    \ 'tsn': "tsNCharcb <++>;"
    \ }

function! TriggerSnippet()
    if pumvisible() | return "\<C-n>" | endif
    let l:col = col('.') - 1
    let l:line = getline('.')
    let l:trigger = matchstr(l:line[0:l:col-1], '\w\+$')
    if has_key(g:cpp_snippets, l:trigger)
        let l:wipe = repeat("\<BS>", len(l:trigger))
        return l:wipe . g:cpp_snippets[l:trigger]
    endif
    return "\<Tab>"
endfunction

augroup CppBoilerplate
    autocmd!
    autocmd FileType c,cpp inoremap <buffer> <expr> <Tab> TriggerSnippet()
    autocmd FileType c,cpp inoremap <buffer> <silent> <C-u> <Esc>/<++><CR>"_c4l
    autocmd FileType c,cpp nnoremap <buffer> <silent> <C-u> /<++><CR>"_c4l
augroup END

" ==============================================================================
" PRESENTATION MODE TOGGLE
" ==============================================================================
function! TogglePresentationMode()
    if g:colors_name ==# 'retro-terminal'
        colorscheme presentation-terminal
        redrawstatus!
        redraw! | echo "[CANVAS INVERTED]: Presentation Mode ACTIVE."
    else
        colorscheme retro-terminal
        redrawstatus!
        redraw! | echo "[CANVAS RESTORED]: Dark Mode ACTIVE."
    endif
endfunction
nnoremap <leader>cv :call TogglePresentationMode()<CR>

" ==============================================================================
" QUICKFIX CANVAS SHIELD 
" ==============================================================================
augroup QuickfixCanvas
    autocmd!
    autocmd FileType qf highlight default link qfSeparator NonText
    autocmd FileType qf highlight default link qfFileName Type
    autocmd FileType qf highlight default link qfLineNr Number
    autocmd FileType qf setlocal nowrap
    autocmd FileType qf setlocal cursorline
augroup END
