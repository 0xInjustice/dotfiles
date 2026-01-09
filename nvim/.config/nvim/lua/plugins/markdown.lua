return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = { "markdown" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("render‑markdown").setup({
			-- general
			enabled = true,
			render_modes = { "n", "c", "t" },

			-- anti‑conceal
			anti_conceal = {
				enabled = true,
				disabled_modes = false,
				above = 0,
				below = 0,
				ignore = {
					code_background = true,
					indent = true,
					sign = true,
					virtual_lines = true,
				},
			},

			-- headings
			heading = {
				width = "block",
				min_width = 30,
			},

			-- latex (inline single line and blocks)
			latex = {
				enabled = true,
				converter = "latex2text",
				highlight = "RenderMarkdownMath",
				position = "above",
				top_pad = 0,
				bottom_pad = 0,
			},

			-- indent
			indent = {
				enabled = true,
				render_modes = false,
				per_level = 2,
				skip_level = 1,
				skip_heading = false,
				icon = "▎",
				priority = 0,
				highlight = "RenderMarkdownIndent",
			},

			-- links
			link = {
				enabled = true,
				render_modes = false,
				footnote = {
					enabled = true,
					icon = "",
					superscript = true,
					prefix = "",
					suffix = "",
				},
				image = "󰥶 ",
				email = "󰀓 ",
				hyperlink = "󰌹 ",
				patterns = {
					{ pattern = "^http", icon = "󰖟 " },
					{ pattern = "github%.com", icon = "󰊤 " },
					{ pattern = "gitlab%.com", icon = "󰮠 " },
					{ pattern = "google%.com", icon = "󰊭 " },
					{ pattern = "neovim%.io", icon = " " },
					{ pattern = "reddit%.com", icon = "󰑍 " },
					{ pattern = "stackoverflow%.com", icon = "󰓌 " },
					{ pattern = "wikipedia%.org", icon = "󰖬 " },
					{ pattern = "youtube%.com", icon = "󰗃 " },
				},
				highlight = "RenderMarkdownLink",
			},

			-- checkbox states
			checkbox = {
				custom = {
					important = {
						raw = "[~]",
						rendered = "󰓎 ",
						highlight = "DiagnosticWarn",
					},
				},
			},

			-- general settings
			preset = "none",
			max_file_size = 10.0,
			debounce = 100,

			-- window options
			win_options = {
				conceallevel = { default = vim.o.conceallevel, rendered = 3 },
				concealcursor = { default = vim.o.concealcursor, rendered = "" },
			},

			-- file_types
			file_types = { "markdown" },
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "RenderMarkdownUpdated",
			callback = function()
				local bufnr = vim.api.nvim_get_current_buf()
				local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
				if #lines > 1 and lines[#lines] == "" then
					vim.api.nvim_buf_set_lines(bufnr, #lines‑1, #lines, false, {})
				end
			end,
		})
	end,
}
