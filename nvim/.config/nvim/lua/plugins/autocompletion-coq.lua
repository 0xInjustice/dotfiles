return {
	"neovim/nvim-lspconfig",
	lazy = false,
	dependencies = {
		{ "ms-jpq/coq_nvim", branch = "coq" },
		{ "ms-jpq/coq.artifacts", branch = "artifacts" },
		{ "ms-jpq/coq.thirdparty", branch = "3p" },
	},

	init = function()
		vim.g.coq_settings = {
			auto_start = true,
			keymap = {
				recommended = false,
			},
		}
	end,

	config = function()
		local coq = require("coq")

		vim.lsp.config(
			"lua_ls",
			coq.lsp_ensure_capabilities({
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})
		)
		vim.lsp.enable("lua_ls")

		vim.lsp.config("pyright", coq.lsp_ensure_capabilities({}))
		vim.lsp.enable("pyright")

		vim.lsp.config("clangd", coq.lsp_ensure_capabilities({}))
		vim.lsp.enable("clangd")

		vim.lsp.config("bashls", coq.lsp_ensure_capabilities({}))
		vim.lsp.enable("bashls")
	end,
}
