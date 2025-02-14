vim.g.mapleader = " "
local keymap = vim.keymap.set

-- Insert and visual mode exit with `jk`
keymap("i", "<leader>jk", "<Esc>")
keymap("v", "<leader>jk", "<Esc>")

-- Delete without affecting the register
keymap("n", "<leader>d", '"_d')
keymap("v", "<leader>d", '"_d')

-- Clear search highlighting
keymap("n", "<leader>nh", ":nohlsearch<CR>")

keymap("v", "<leader>p", '"_dp')

-- Split windows
keymap("n", "<leader>sv", ":vsplit<CR>")
keymap("n", "<leader>sh", ":split<CR>")

-- Window navigation
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-l>", "<C-w>l")

-- Close the current split
keymap("n", "sx", ":close<CR>")

keymap("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })
