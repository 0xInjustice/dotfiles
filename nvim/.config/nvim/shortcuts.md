# Neovim Shortcuts

## Custom Shortcuts

### Formatter

- `<leader>mp`: Format file or range (in visual mode)

### Telescope

- `<leader>ff`: Find Files
- `<leader>fg`: Search Text
- `<leader>fb`: List Buffers
- `<leader>fh`: Help Tags
- `<leader>fm`: Marks
- `<leader>fk`: Keymaps
- `<leader>fc`: Commands
- `<leader>fch`: Command History
- `<leader>fsh`: Search History
- `<leader>fcs`: Colorschemes
- `<leader>fo`: Old Files
- `<leader>fq`: Quickfix List
- `<leader>fl`: Location List
- `<leader>fj`: Jumplist
- `<leader>ft`: Tags

### Linting

- `<leader>l`: Trigger linting for current file

### Harpoon

- `<leader>aa`: Add file to harpoon
- `<leader>as`: Toggle harpoon quick menu

### GitSigns

- `]h`: Next Hunk
- `[h`: Prev Hunk
- `<leader>hs`: Stage hunk
- `<leader>hr`: Reset hunk
- `<leader>hS`: Stage buffer
- `<leader>hR`: Reset buffer
- `<leader>hu`: Undo stage hunk
- `<leader>hp`: Preview hunk
- `<leader>hb`: Blame line
- `<leader>hB`: Toggle line blame
- `<leader>hd`: Diff this
- `<leader>hD`: Diff this ~
- `ih`: Gitsigns select hunk

### Keymaps

- `<leader>d`: Delete without affecting the register
- `<leader>nh`: Clear search highlighting
- `<leader>p`: Pastes without yanking the replaced text
- `<leader>sv`: Split window vertically
- `<leader>sh`: Split window horizontally
- `<leader>sx`: Close current window
- `<leader>se`: Make windows equal size
- `<leader>tt`: Open terminal
- `<C-h>`: Navigate to left window
- `<C-l>`: Navigate to right window
- `<leader>to`: Open new tab
- `<leader>tx`: Close current tab
- `<leader>tn`: Go to next tab
- `<leader>tp`: Go to previous tab
- `<leader>tf`: Open current buffer in new tab

## Default Neovim Shortcuts

### Basic Navigation (Normal Mode)

- `h`, `j`, `k`, `l`: Move cursor left, down, up, right.
- `w`: Jump to the start of the next word.
- `b`: Jump to the start of the previous word.
- `e`: Jump to the end of the current word.
- `0`: Jump to the beginning of the line (first column).
- `^`: Jump to the first non-blank character of the line.
- `$`: Jump to the end of the line.
- `gg`: Go to the first line of the document.
- `G`: Go to the last line of the document.
- `{number}G`: Go to a specific line number.
- `Ctrl+d`: Scroll half a page down.
- `Ctrl+u`: Scroll half a page up.
- `Ctrl+f`: Scroll a full page forward.
- `Ctrl+b`: Scroll a full page backward.

### File Operations

- `:e {filename}`: Open a file for editing.
- `:w`: Save the current file.
- `:w {filename}`: Save the current file with a new name.
- `:q`: Quit the current window (fails if unsaved changes).
- `:q!`: Quit without saving (discard changes).
- `:wq` or `:x`: Save and quit.
- `ZZ`: Save and quit (in Normal mode).
- `ZQ`: Quit without saving (in Normal mode).

### Editing Commands (Normal Mode)

- `i`: Enter Insert mode before the cursor.
- `a`: Enter Insert mode after the cursor.
- `I`: Enter Insert mode at the beginning of the line.
- `A`: Enter Insert mode at the end of the line.
- `o`: Open a new line below the current line and enter Insert mode.
- `O`: Open a new line above the current line and enter Insert mode.
- `x`: Delete the character under the cursor.
- `dd`: Delete the current line.
- `d{motion}`: Delete text specified by the motion (e.g., `dw` deletes a word).
- `yy`: Copy (yank) the current line.
- `y{motion}`: Copy text specified by the motion.
- `p`: Paste text after the cursor.
- `P`: Paste text before the cursor.
- `u`: Undo the last change.
- `Ctrl+r`: Redo the last undone change.
- `r`: Replace the character under the cursor.
- `R`: Enter replace mode.
- `cw`: Change from cursor to end of word and enter Insert mode.

### Visual Mode

- `v`: Enter Visual mode (character selection).
- `V`: Enter Visual Line mode (line selection).
- `Ctrl+v`: Enter Visual Block mode (block selection).
- Once in Visual mode, use navigation keys to select text, then use `d` to delete, `y` to yank (copy), etc.

### Search and Replace

- `/{pattern}`: Search forward for a pattern.
- `?{pattern}`: Search backward for a pattern.
- `n`: Jump to the next match.
- `N`: Jump to the previous match.
- `:%s/{search}/{replace}/g`: Find and replace all instances of `{search}` with `{replace}` throughout the file.
- `:%s/{search}/{replace}/gc`: Find and replace with confirmation.

### Windows and Tabs

- `:split` or `:sp`: Split the window horizontally.
- `:vsplit` or `:vs`: Split the window vertically.
- `Ctrl-w h/j/k/l`: Navigate between windows (left/down/up/right).
- `Ctrl-w o`: Make the current window the only one.
- `:tabnew`: Create a new tab.
- `gt`: Go to the next tab.
- `gT`: Go to the previous tab.
- `:tabclose`: Close the current tab.
- `:tabonly`: Close all other tabs.

### Marks and Jumps

- `m{a-z}`: Set a mark at the current position (lowercase for file-local).
- `'{mark}`: Jump to the line of the mark.
- `` `{mark}``: Jump to the exact position of the mark.
- `Ctrl-o`: Jump to an older position in the jump list.
- `Ctrl-i`: Jump to a newer position in the jump list.
