let mapleader = " "
syntax enable
filetype plugin indent on

set hlsearch
set incsearch
set smartcase
set showmatch
set hidden
set number
set relativenumber
set ruler
set showcmd
set ttyfast
set background=dark
set ignorecase
set gdefault
set splitright
set splitbelow
set completeopt=menuone,noselect,popup
set lazyredraw
set updatetime=200
set shortmess+=c
set shadafile=DEFAULT

autocmd VimLeavePre * silent! wshada!
autocmd VimEnter * silent! rshada!

try
    colorscheme retro-terminal
catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme default
endtry

set sessionoptions+=globals
set sessionoptions+=localoptions
set sessionoptions+=blank
set sessionoptions+=buffers
set sessionoptions+=curdir
set sessionoptions+=folds
set sessionoptions+=help
set sessionoptions+=resize
set sessionoptions+=tabpages
set sessionoptions+=terminal
set sessionoptions+=winsize
set switchbuf=usetab,newtab
set scrolloff=5
set sidescrolloff=5
set confirm
set laststatus=2
set statusline=
set statusline+=%f
set statusline+=%m%r%h%w
set statusline+=%=
set statusline+=%{&filetype==''?'text':&filetype}
set statusline+=\ [%{&fileencoding}]
set statusline+=\ %l:%c
set statusline+=\ %p%%
set wildignore+=*.o,*.obj,*.a,*.so,*.dll,*.exe
set wildignore+=*.pyc,*.class
set wildignore+=*/.git/*,*/node_modules/*,*/target/*

if has('clipboard')
    set clipboard+=unnamedplus
endif

set autoindent
set copyindent
set shiftwidth=4
set tabstop=4
set expandtab
if exists("*syntaxcomplete#Complete")
    set omnifunc=syntaxcomplete#Complete
endif
set formatoptions=tcqrn1
set backspace=indent,eol,start
set foldmethod=indent
set foldlevelstart=99

set wildmenu
set wildmode=list:longest,full
if has('nvim')
    set wildoptions=pum
    set pumblend=15
endif

nnoremap <leader>nh :nohlsearch<CR>
nnoremap n nzzzv
nnoremap N Nzzzv

nnoremap <leader>sv :vsplit<CR>
nnoremap <leader>sh :split<CR>
nnoremap <leader>sx :close<CR>
nnoremap <leader>se <C-w>=
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

nnoremap <leader>bn :bn<CR>
nnoremap <leader>bp :bp<CR>
nnoremap <leader>bb :enew<CR>
nnoremap <leader>bd :bd<CR>
nnoremap <leader>ba :ba<CR>
nnoremap <leader>bw :wa<CR>
nnoremap <leader>bq :xa<CR>
nnoremap <leader>bl :ls<CR>:b<Space>

nnoremap <leader>to :tabnew<CR>
nnoremap <leader>tx :tabclose<CR>
nnoremap <leader>tn :tabn<CR>
nnoremap <leader>tp :tabp<CR>
nnoremap <leader>tf :tabnew %<CR>

if has('win32') || has('win64')
else
    set path+=/usr/include/**,/usr/local/include/**
endif

set path+=.,,
set tags=tags;/

nnoremap <leader>fw :execute "vimgrep /" . expand("<cword>") . "/j **/*" <Bar> cw<CR>
nnoremap <leader>ff :vimgrep // **/*<Left><Left><Left><Left><Left><Left>
nnoremap <leader>fl :execute "vimgrep /" . escape(@/, '/') . "/j %" <Bar> cw<CR>

nnoremap <leader>cn :cnext<CR>
nnoremap <leader>cp :cprev<CR>
nnoremap <leader>co :copen<CR>
nnoremap <leader>cl :cclose<CR>

nnoremap [I [I:let nr = input("Which one: ")<Bar>exe "normal " . nr . "[\t"<CR>

nnoremap <leader>d "_d
vnoremap <leader>d "_d
nnoremap <leader>tt :terminal<CR>
tnoremap <Esc> <C-\><C-n>
nnoremap <leader>m :make<CR>
nnoremap <leader>ww :w<CR>
nnoremap <leader>wq :wqa<CR>
nnoremap <leader><leader>q :q<CR>
nnoremap <leader>qq :qa!<CR>
nnoremap <leader>'' :reg<CR>

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 28
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_keepdir = 1
let g:netrw_fastbrowse = 0
let g:netrw_preview = 1
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'

if has('win32') || has('win64')
    let g:netrw_localcopydircmd = 'xcopy /E /I /Y'
else
    let g:netrw_localcopydircmd = 'cp -r'
endif

function! ToggleExplorer()
    for win in getwininfo()
        if getbufvar(win.bufnr, '&filetype') ==# 'netrw'
            execute win.winnr . 'wincmd w'
            close
            return
        endif
    endfor
    Lexplore
endfunction

nnoremap <silent> <leader>ee <Cmd>call ToggleExplorer()<CR>
nnoremap <silent> <leader>er <Cmd>Explore<CR>
nnoremap <silent><buffer> <C-h> <C-w>h
nnoremap <silent><buffer> <C-j> <C-w>j
nnoremap <silent><buffer> <C-k> <C-w>k
nnoremap <silent><buffer> <C-l> <C-w>l

function! s:OpenInWindow()
    let l:wins = []
    for l:win in getwininfo()
        if !l:win.quickfix && getbufvar(l:win.bufnr, '&filetype') !=# 'netrw'
            call add(l:wins, l:win)
        endif
    endfor

    if empty(l:wins)
        execute "normal! \<CR>"
        return
    endif

    let l:letters = split('ABCDEFGHIJKLMNOPQRSTUVWXYZ', '\zs')

    redraw
    echo "Select destination window:"

    for l:i in range(len(l:wins))
        let l:name = bufname(winbufnr(l:wins[l:i].winnr))
        if empty(l:name)
            let l:name = '[No Name]'
        else
            let l:name = fnamemodify(l:name, ':t')
        endif
        echo l:letters[l:i] . ' : ' . l:name
    endfor

    let l:key = nr2char(getchar())
    let l:index = index(l:letters, toupper(l:key))

    if l:index < 0 || l:index >= len(l:wins)
        echo "Cancelled"
        return
    endif

    let l:file = expand('<cfile>')

    execute l:wins[l:index].winnr . 'wincmd w'
    execute 'edit ' . fnameescape(l:file)
endfunction

augroup NativeExplorer
    autocmd!
    autocmd FileType netrw call s:NetrwSetup()
augroup END

function! s:NetrwSetup()
    setlocal nowrap
    setlocal nonumber
    setlocal norelativenumber
    setlocal signcolumn=no
    setlocal cursorline
    setlocal nospell
    setlocal bufhidden=wipe
    setlocal winfixwidth

    nnoremap <silent><buffer> h -
    nnoremap <silent><buffer> l <CR>
    nnoremap <silent><buffer> q <Cmd>call ToggleExplorer()<CR>
    nnoremap <silent><buffer> r <Cmd>edit<CR>
    nnoremap <silent><buffer> . gh
    nnoremap <silent><buffer> a %
    nnoremap <silent><buffer> R R
    nnoremap <silent><buffer> D D
    nnoremap <silent><buffer> y mf
    nnoremap <silent><buffer> p mc
    nnoremap <silent><buffer> s o
    nnoremap <silent><buffer> v v
    nnoremap <silent><buffer> t <C-w>gf
    nnoremap <silent><buffer> H u
    nnoremap <silent><buffer> o <Cmd>call <SID>OpenInWindow()<CR>
endfunction

inoremap { {}<Left>
inoremap [ []<Left>
inoremap ( ()<Left>
inoremap ' ''<Left>
inoremap " ""<Left>
inoremap ` ``<Left>

inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"

if has('persistent_undo')
    if has('win32') || has('win64')
        let target_path = expand('~/AppData/Local/nvim/undodir')
    else
        let target_path = expand('~/.local/state/nvim/undo')
    endif
    if !isdirectory(target_path)
        call mkdir(target_path, "p", 0700)
    endif
    let &undodir = target_path
    set undofile
endif

highlight ExtraWhitespace ctermbg=red guibg=red
augroup Whitespace
    autocmd!
    autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
    autocmd BufEnter * match ExtraWhitespace /\s\+$/
augroup END
nnoremap <leader>W :%s/\s\+$//e<CR>

augroup AutoSaveGroup
    autocmd!
    autocmd BufLeave,FocusLost * if &buftype ==# '' && &modifiable && expand('%') !=# '' | silent! wall | endif
    autocmd TextChanged,InsertLeave * if &buftype ==# '' && &modifiable && expand('%') !=# '' | silent! update | endif
augroup END

augroup CppAdvancedHighlighting
    autocmd!
    autocmd Syntax c,cpp syntax match cCustomOperator "\v([-+=<>!&|~^%]+|(/|\*)@<!/(/|\*)@!|(/)@<!\*(/)@!)"
    autocmd Syntax c,cpp highlight link cCustomOperator Operator
    autocmd Syntax c,cpp syntax keyword cIgnore if while for switch return sizeof
    autocmd Syntax c,cpp syntax match cCustomFunc "\v<[A-Za-z_]\w*\ze\s*\("
    autocmd Syntax c,cpp highlight link cIgnore Statement
    autocmd Syntax c,cpp highlight link cCustomFunc Function
    autocmd Syntax c,cpp syntax match cCustomClass "\v<[A-Z][a-zA-Z0-9_]*>"
    autocmd Syntax c,cpp syntax match cCustomTypedef "\v\w+_t>"
    autocmd Syntax c,cpp syntax match cProjectTypes "\v<(ts|c)[A-Z][a-zA-Z0-9_]*>"
    autocmd Syntax c,cpp highlight link cCustomClass Type
    autocmd Syntax c,cpp highlight link cCustomTypedef Type
    autocmd Syntax c,cpp highlight link cProjectTypes Type
augroup END

function! GetSessionDir()
    if has('win32') || has('win64')
        return expand('~/AppData/Local/nvim-data/sessions/')
    else
        return expand('~/.local/share/nvim/sessions/')
    endif
endfunction

function! GetSanitizedProjectID()
    let l:raw_path = getcwd()
    let l:path = substitute(l:raw_path, '[/\\]', '_', 'g')
    let l:path = substitute(l:path, ':', '', 'g')
    return l:path
endfunction

function! SaveTaggedSession()
    let l:session_dir = GetSessionDir()
    if !isdirectory(l:session_dir)
        call mkdir(l:session_dir, "p", 0700)
    endif

    let l:display_name = fnamemodify(getcwd(), ':t')
    let l:project_id = GetSanitizedProjectID()

    let l:glob_pattern = l:session_dir . l:project_id . '_*.vim'
    let l:sessions = split(glob(l:glob_pattern), '\n')

    redraw!
    echo "--- Save Session: " . l:display_name . " ---"
    echo "0: [DELETE ALL sessions for this project]"

    let l:i = 1
    for l:s in l:sessions
        let l:filename = fnamemodify(l:s, ':t:r')
        let l:tag = split(l:filename, '_')[-1]
        echo l:i . ": Overwrite [" . l:tag . "]"
        let l:i += 1
    endfor

    echo "----------------------------------------"
    let l:choice = input("Enter number (0-" . len(l:sessions) . ") or type NEW tag name: ")

    if l:choice ==# '0'
        for l:s in l:sessions
            call delete(l:s)
        endfor
        redraw!
        echo "Deleted all sessions for " . l:display_name
        return

    elseif l:choice =~ '^\d\+$' && l:choice > 0 && l:choice <= len(l:sessions)
        let l:target_file = l:sessions[l:choice - 1]
        let l:tag = split(fnamemodify(l:target_file, ':t:r'), '_')[-1]

        call delete(l:target_file)
        silent execute 'mksession! ' . fnameescape(l:target_file)
        redraw!
        echo "Overwrote session: " . l:display_name . " [" . l:tag . "]"

    elseif l:choice != ""
        let l:tag = substitute(l:choice, '[^a-zA-Z0-9_-]', '', 'g')
        if l:tag == ""
            let l:tag = "main"
        endif

        let l:target_file = l:session_dir . l:project_id . '_' . l:tag . '.vim'
        if filereadable(l:target_file)
            call delete(l:target_file)
        endif
        silent execute 'mksession! ' . fnameescape(l:target_file)
        redraw!
        echo "Saved NEW session: " . l:display_name . " [" . l:tag . "]"

    else
        redraw!
        echo "Canceled."
    endif
endfunction

function! LoadTaggedSession()
    let l:session_dir = GetSessionDir()
    let l:display_name = fnamemodify(getcwd(), ':t')
    let l:project_id = GetSanitizedProjectID()

    let l:glob_pattern = l:session_dir . l:project_id . '_*.vim'
    let l:sessions = split(glob(l:glob_pattern), '\n')

    if empty(l:sessions)
        echo "No sessions found for this directory."
        return
    endif

    redraw!
    echo "--- Load Session: " . l:display_name . " ---"
    echo "0: [DELETE ALL sessions for this project]"

    let l:i = 1
    for l:s in l:sessions
        let l:filename = fnamemodify(l:s, ':t:r')
        let l:tag = split(l:filename, '_')[-1]
        echo l:i . ": Load [" . l:tag . "]"
        let l:i += 1
    endfor

    let l:choice = input("Enter number to load (or 0 to delete): ")

    if l:choice ==# '0'
        for l:s in l:sessions
            call delete(l:s)
        endfor
        redraw!
        echo "Deleted all sessions for " . l:display_name

    elseif l:choice =~ '^\d\+$' && l:choice > 0 && l:choice <= len(l:sessions)
        let l:target_idx = l:choice - 1

        silent! %bwipeout!

        execute 'source ' . fnameescape(l:sessions[l:target_idx])

        let l:filename = fnamemodify(l:sessions[l:target_idx], ':t:r')
        let l:tag = split(l:filename, '_')[-1]
        redraw!
        echo "Loaded workspace: " . l:display_name . " [" . l:tag . "]"

    else
        redraw!
        echo "Canceled."
    endif
endfunction

nnoremap <leader>ms :call SaveTaggedSession()<CR>
nnoremap <leader>ml :call LoadTaggedSession()<CR>

if has('nvim')
    set inccommand=split
    set smoothscroll
endif

augroup NeovimSmartUI
    autocmd!
    if has('nvim')
        autocmd TextYankPost * silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=150})
    endif

    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

nnoremap <leader>term :botright split <Bar> resize 10 <Bar> terminal<CR>i

function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction
nnoremap <leader>qf :call ToggleQuickFix()<CR>

augroup NativeDocs
    autocmd!
    if !has('win32') && !has('win64')
        autocmd FileType c,cpp setlocal keywordprg=:Man
    endif
augroup END

augroup NativeSnippets
    autocmd!
    autocmd FileType c,cpp iabbrev <buffer> #i #include <><Left>
    autocmd FileType c,cpp iabbrev <buffer> mainf int main(int argc, char** argv) {<CR>return 0;<CR>}<Up><Up><End><CR>
    autocmd FileType c,cpp iabbrev <buffer> fori for (int i = 0; i < n; ++i) {<CR>}<Up><End><CR>
augroup END

if has('nvim')
    set diffopt+=linematch:60
endif
if has('nvim')
    nnoremap <silent> ]d <Cmd>lua vim.diagnostic.goto_next()<CR>
    nnoremap <silent> [d <Cmd>lua vim.diagnostic.goto_prev()<CR>
    nnoremap <silent> <leader>e <Cmd>lua vim.diagnostic.open_float()<CR>
endif
