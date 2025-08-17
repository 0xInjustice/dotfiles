return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp", -- LSP source
		"hrsh7th/cmp-buffer", -- Buffer source
		"hrsh7th/cmp-path", -- File system paths
		"hrsh7th/cmp-cmdline", -- Command-line completions
		"saadparwaiz1/cmp_luasnip", -- Snippet completions
		{
			"L3MON4D3/LuaSnip", -- Snippet engine
			build = "make install_jsregexp",
		},
		"rafamadriz/friendly-snippets", -- Predefined snippets
		"onsails/lspkind.nvim", -- VSCode-like pictograms
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")

		-- Load friendly snippets
		require("luasnip.loaders.from_vscode").lazy_load()

		-- Helper function to check for words before the cursor
		local has_words_before = function()
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end

		cmp.setup({
			completion = {
				completeopt = "menu,menuone,preview,noselect",
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(), -- Previous suggestion
				["<C-j>"] = cmp.mapping.select_next_item(), -- Next suggestion
				["<C-b>"] = cmp.mapping.scroll_docs(-4), -- Scroll docs up
				["<C-f>"] = cmp.mapping.scroll_docs(4), -- Scroll docs down
				["<C-Space>"] = cmp.mapping.complete(), -- Trigger completion
				["<C-e>"] = cmp.mapping.abort(), -- Close completion window
				["<CR>"] = cmp.mapping.confirm({ select = false }), -- Confirm selection
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					elseif has_words_before() then
						cmp.complete()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),

			sources = cmp.config.sources({
				{ name = "nvim_lsp" }, -- LSP completions
				{ name = "luasnip" }, -- Snippet completions
				{ name = "buffer" }, -- Buffer words
				{ name = "path" }, -- File paths
			}),
			formatting = {
				format = lspkind.cmp_format({
					mode = "symbol_text", -- Show symbol and text
					maxwidth = 50, -- Max width of popup
					ellipsis_char = "...", -- Ellipsis for truncated entries
					menu = {
						buffer = "[Buf]",
						nvim_lsp = "[LSP]",
						path = "[Path]",
						luasnip = "[Snip]",
					},
				}),
			},
			performance = {
				debounce = 60,
				throttle = 30,
				fetching_timeout = 200,
			},
		})

		-- Command-line completion
		cmp.setup.cmdline("/", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline" },
			}),
		})

		-- LSP capabilities
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		-- Use these capabilities when setting up LSP servers
		-- Example:
		-- require("lspconfig").clangd.setup({
		--   capabilities = capabilities,
		-- })
	end,
}
