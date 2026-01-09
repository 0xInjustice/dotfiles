vim.g.mapleader = " "
local keymap = vim.keymap.set

keymap("n", "<leader>d", '"_d')
keymap("v", "<leader>d", '"_d')

keymap("n", "<leader>nh", ":nohlsearch<CR>")

keymap("n", "<leader>sv", ":vsplit<CR>")
keymap("n", "<leader>sh", ":split<CR>")
keymap("n", "<leader>sx", ":close<CR>")
keymap("n", "<leader>se", "<C-w>=")

keymap("n", "<leader>tt", ":terminal<CR>")

keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-l>", "<C-w>l")

keymap("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

vim.g.coq_settings = {
	keymap = {
		recommended = false,
	},
}

keymap("i", "<C-j>", function()
	return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-j>"
end, { expr = true, noremap = true })

keymap("i", "<C-k>", function()
	return vim.fn.pumvisible() == 1 and "<C-p>" or "<C-k>"
end, { expr = true, noremap = true })
