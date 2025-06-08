return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		-- 🧰 Mason bootstrap
		require("mason").setup()
		local mason_lsp = require("mason-lspconfig")

		-- 🔧 Common capabilities and on_attach
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		local function on_attach(client, bufnr)
			local km = vim.keymap
			local o = { buffer = bufnr, silent = true }
			km.set("n", "gR", "<cmd>Telescope lsp_references<CR>", o)
			km.set("n", "gD", vim.lsp.buf.declaration, o)
			km.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", o)
			km.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", o)
			km.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", o)
			km.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, o)
			km.set("n", "<leader>rn", vim.lsp.buf.rename, o)
			km.set("n", "[d", vim.diagnostic.goto_prev, o)
			km.set("n", "]d", vim.diagnostic.goto_next, o)
			km.set("n", "K", vim.lsp.buf.hover, o)
			km.set("n", "<leader>ds", vim.diagnostic.open_float, o)
		end

		-- 🔔 Custom gutter signs
		for type, icon in pairs({ Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }) do
			vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticSign" .. type })
		end

		-- 📊 Diagnostic display config
		vim.diagnostic.config({
			virtual_text = {
				prefix = "●",
				spacing = 2,
				-- optional custom format:
				-- format = function(d) return d.message end,
			},
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = {
				border = "rounded",
				source = "if_many",
				prefix = "",
			},
		})

		-- ⚙️ Auto-show diagnostics on hover
		vim.o.updatetime = 250
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			callback = function()
				-- don't overlap other floating windows
				local floats = vim.api.nvim_tabpage_list_wins(0)
				for _, w in ipairs(floats) do
					if vim.api.nvim_win_get_config(w).zindex then
						return
					end
				end
				vim.diagnostic.open_float(nil, { scope = "cursor", focusable = false })
			end,
		})

		-- 🛡️ LSP server setup with Mason
		mason_lsp.setup({
			ensure_installed = { "clangd", "svelte", "graphql", "emmet_ls", "lua_ls" },
			automatic_installation = true,
			handlers = {
				function(server)
					require("lspconfig")[server].setup({
						capabilities = capabilities,
						on_attach = on_attach,
					})
				end,
				clangd = function()
					require("lspconfig").clangd.setup({
						capabilities = capabilities,
						on_attach = on_attach,
						cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed" },
						filetypes = { "c", "cpp", "objc", "objcpp" },
					})
				end,
				svelte = function()
					require("lspconfig").svelte.setup({
						capabilities = capabilities,
						on_attach = function(client, bufnr)
							on_attach(client, bufnr)
							vim.api.nvim_create_autocmd("BufWritePost", {
								buffer = bufnr,
								pattern = { "*.js", "*.ts" },
								callback = function(ctx)
									client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
								end,
							})
						end,
					})
				end,
				-- graphql, emmet_ls, lua_ls — covered by default handler
			},
		})
	end,
}
