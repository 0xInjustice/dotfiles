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
		local function common_on_attach(client, bufnr)
			local bufopts = { buffer = bufnr, silent = true }
			local km = vim.keymap
			-- ◾ set tab and indentation to 8 spaces, no expandtab
			vim.bo[bufnr].tabstop = 4
			vim.bo[bufnr].shiftwidth = 4
			vim.bo[bufnr].softtabstop = 4
			vim.bo[bufnr].expandtab = false
			vim.bo[bufnr].autoindent = true
			vim.bo[bufnr].smartindent = true
			-- ◾ usual LSP keymaps
			km.set("n", "gR", "<cmd>Telescope lsp_references<CR>", bufopts)
			km.set("n", "gD", vim.lsp.buf.declaration, bufopts)
			km.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", bufopts)
			km.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", bufopts)
			km.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", bufopts)
			km.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, bufopts)
			km.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
			km.set("n", "[d", vim.diagnostic.goto_prev, bufopts)
			km.set("n", "]d", vim.diagnostic.goto_next, bufopts)
			km.set("n", "K", vim.lsp.buf.hover, bufopts)
			km.set("n", "<leader>ds", vim.diagnostic.open_float, bufopts)
		end

		-- 🔔 Custom gutter signs
		for type, icon in pairs({ Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }) do
			vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticSign" .. type })
		end

		-- 📊 Diagnostic display config
		vim.diagnostic.config({
			virtual_text = { prefix = "●", spacing = 2 },
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = { border = "rounded", source = "if_many", prefix = "" },
		})

		-- ⚙️ Auto-show diagnostics on hover
		vim.o.updatetime = 250
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

		-- 🛡️ LSP server setup with Mason
		mason_lsp.setup({
			ensure_installed = { "clangd", "svelte", "graphql", "emmet_ls", "lua_ls" },
			automatic_installation = true,
			handlers = {
				-- default handler for all other servers
				function(server)
					require("lspconfig")[server].setup({ capabilities = capabilities, on_attach = common_on_attach })
				end,
				-- clangd with indent-specific on_attach
				clangd = function()
					require("lspconfig").clangd.setup({
						capabilities = capabilities,
						on_attach = function(client, bufnr)
							-- only clangd: enforce 8-space indent settings
							vim.bo[bufnr].tabstop = 4
							vim.bo[bufnr].shiftwidth = 4
							vim.bo[bufnr].softtabstop = 4
							vim.bo[bufnr].expandtab = false
							vim.bo[bufnr].autoindent = true
							vim.bo[bufnr].smartindent = true
							-- then call common mappings
							common_on_attach(client, bufnr)
						end,
						cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed" },
						filetypes = { "c", "cpp", "objc", "objcpp" },
					})
				end,
				-- svelte with post-write notify
				svelte = function()
					require("lspconfig").svelte.setup({
						capabilities = capabilities,
						on_attach = function(client, bufnr)
							common_on_attach(client, bufnr)
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
			},
		})
	end,
}
