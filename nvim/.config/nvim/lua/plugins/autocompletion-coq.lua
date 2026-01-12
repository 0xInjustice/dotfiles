return {
	"neovim/nvim-lspconfig",
	lazy = false,
	dependencies = {
		{ "ms-jpq/coq_nvim", branch = "coq" },
		{ "ms-jpq/coq.artifacts", branch = "artifacts" },
		{ "ms-jpq/coq.thirdparty", branch = "3p" },
	},

	init = function()
		-- 1. Global COQ Settings
		vim.g.coq_settings = {
			auto_start = true,
			keymap = {
				recommended = false, -- Disable default maps
			},
		}

		-- 2. Force Keymap using Vimscript (Highest Priority)
		-- This ensures that when the menu is open (pumvisible), Enter confirms selection (<C-y>)
		vim.cmd([[
            inoremap <silent><expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
        ]])
	end,

	config = function()
		local coq = require("coq")
		local lspconfig = require("lspconfig")

		-- 3. Setup Servers
		-- NOTE: Your lua_ls is corrupt (based on logs).
		-- It will error until you reinstall it via system package manager or Mason.
		lspconfig.lua_ls.setup(coq.lsp_ensure_capabilities({
			settings = { Lua = { diagnostics = { globals = { "vim" } } } },
		}))

		lspconfig.pyright.setup(coq.lsp_ensure_capabilities({}))
		lspconfig.clangd.setup(coq.lsp_ensure_capabilities({}))
		lspconfig.bashls.setup(coq.lsp_ensure_capabilities({}))
	end,
}
