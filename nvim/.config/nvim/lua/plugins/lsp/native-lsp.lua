return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },

	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",

		-- BLINK
		"saghen/blink.cmp",

		-- FZF-Lua
		{ "ibhagwan/fzf-lua", dependencies = { "nvim-tree/nvim-web-devicons" } },

		"folke/neodev.nvim",
	},

	config = function()
		-- === CORE REQUIRES ===
		require("neodev").setup()
		require("mason").setup()

		local mason_lsp = require("mason-lspconfig")
		local lspconfig = require("lspconfig")
		local fzf = require("fzf-lua")

		-- === BLINK LSP CAPABILITIES ===
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		-- === ATTACH LOGIC ===
		local on_attach = function(_, bufnr)
			local opts = { buffer = bufnr, silent = true }

			-- Indentation (unchanged)
			vim.bo[bufnr].tabstop = 4
			vim.bo[bufnr].shiftwidth = 4
			vim.bo[bufnr].softtabstop = 4
			vim.bo[bufnr].expandtab = false
			vim.bo[bufnr].autoindent = true
			vim.bo[bufnr].smartindent = true

			-- FZF-Lua
			vim.keymap.set("n", "gR", fzf.lsp_references, opts)
			vim.keymap.set("n", "gd", fzf.lsp_definitions, opts)
			vim.keymap.set("n", "gi", fzf.lsp_implementations, opts)
			vim.keymap.set("n", "gt", fzf.lsp_typedefs, opts)
			vim.keymap.set({ "n", "v" }, "<leader>ca", fzf.lsp_code_actions, opts)

			-- LSP
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "<leader>ds", vim.diagnostic.open_float, opts)
		end

		-- === DIAGNOSTICS ===
		vim.diagnostic.config({
			virtual_text = { prefix = "●", spacing = 2 },
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = {
				border = "rounded",
				source = "if_many",
				prefix = "",
			},
		})

		-- Auto-hover diagnostics (unchanged)
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			callback = function()
				for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
					if vim.api.nvim_win_get_config(w).zindex then
						return
					end
				end
				vim.diagnostic.open_float(nil, { scope = "cursor", focusable = false })
			end,
		})

		-- === SERVERS ===
		mason_lsp.setup({
			ensure_installed = {
				"clangd",
				"svelte",
				"graphql",
				"emmet_ls",
				"lua_ls",
			},

			handlers = {
				-- Default
				function(server_name)
					lspconfig[server_name].setup({
						capabilities = capabilities,
						on_attach = on_attach,
					})
				end,

				-- clangd
				clangd = function()
					lspconfig.clangd.setup({
						capabilities = capabilities,
						on_attach = on_attach,
						cmd = {
							"clangd",
							"--background-index",
							"--clang-tidy",
							"--completion-style=detailed",
						},
						filetypes = { "c", "cpp", "objc", "objcpp" },
					})
				end,

				-- svelte
				svelte = function()
					lspconfig.svelte.setup({
						capabilities = capabilities,
						on_attach = function(client, bufnr)
							on_attach(client, bufnr)

							vim.api.nvim_create_autocmd("BufWritePost", {
								buffer = bufnr,
								pattern = { "*.js", "*.ts" },
								callback = function(ctx)
									client.notify("$/onDidChangeTsOrJsFile", {
										uri = ctx.match,
									})
								end,
							})
						end,
					})
				end,
			},
		})
	end,
}
