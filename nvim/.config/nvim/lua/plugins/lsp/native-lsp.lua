return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"saghen/blink.cmp",
		"folke/neodev.nvim",
		{ "ibhagwan/fzf-lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
	},
	config = function()
		require("neodev").setup()

		local lspconfig_configs = require("lspconfig.configs")
		local mason_lspconfig = require("mason-lspconfig")
		local fzf = require("fzf-lua")
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		-- === LSP ATTACH EVENT ===
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local bufnr = ev.buf
				local opts = { buffer = bufnr, silent = true }

				-- Buffer local options
				vim.bo[bufnr].tabstop = 4
				vim.bo[bufnr].shiftwidth = 4
				vim.bo[bufnr].expandtab = false

				-- FZF-Lua mappings
				vim.keymap.set("n", "gd", fzf.lsp_definitions, opts)
				vim.keymap.set("n", "gR", fzf.lsp_references, opts)
				vim.keymap.set("n", "gi", fzf.lsp_implementations, opts)
				vim.keymap.set("n", "gt", fzf.lsp_typedefs, opts)
				-- vim.keymap.set({ "n", "v" }, "<leader>ca", fzf.lsp_code_actions, opts)

				-- Built-in LSP mappings
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
				vim.keymap.set("n", "<leader>ds", vim.diagnostic.open_float, opts)

				-- Clangd specific mapping
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if client and client.name == "clangd" then
					vim.keymap.set("n", "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", {
						buffer = bufnr,
						desc = "Switch Source/Header",
					})
				end
			end,
		})

		-- === DIAGNOSTICS CONFIG ===
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

		-- === LSP SERVERS SETUP ===
		local function setup_server(server_name)
			local config = {
				capabilities = capabilities,
			}

			if server_name == "clangd" then
				local clangd_caps = require("blink.cmp").get_lsp_capabilities()
				clangd_caps.offsetEncoding = { "utf-16" }
				config.capabilities = clangd_caps
				config.cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--header-insertion=iwyu",
					"--fallback-style=llvm",
				}
			elseif server_name == "svelte" then
				config.on_attach = function(client, bufnr)
					vim.api.nvim_create_autocmd("BufWritePost", {
						buffer = bufnr,
						pattern = { "*.js", "*.ts" },
						callback = function(ctx)
							client.notify("$/onDidChangeTsOrJsFile", {
								uri = ctx.match,
							})
						end,
					})
				end
			end

			-- Use modern Neovim 0.11+ API via nvim-lspconfig
			local server_config = lspconfig_configs[server_name]
			if server_config then
				server_config.setup(config)
			end
		end

		-- Setup all installed servers from Mason
		local installed_servers = mason_lspconfig.get_installed_servers()
		for _, server_name in ipairs(installed_servers) do
			-- Check if it's actually an LSP server (avoid things like stylua)
			if lspconfig_configs[server_name] then
				setup_server(server_name)
			end
		end
	end,
}
