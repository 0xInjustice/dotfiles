-- Telescope for fuzzy finding
return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("telescope").setup({})
        vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find Files" })
        vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Search Text" })
    end,
}

