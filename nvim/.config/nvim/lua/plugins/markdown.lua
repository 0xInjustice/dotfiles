return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = { "markdown" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons", -- required for icons
	},
	config = function()
		require("render-markdown").setup({
			render_modes = { "n", "c", "t" },
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
			heading = {
				width = "block",
				min_width = 30,
			},
			latex = {
				enabled = true,
				converter = "latex2text",
				highlight = "RenderMarkdownMath",
				position = "above",
				top_pad = 0,
				bottom_pad = 0,
			},
			indent = {
				enabled = true,
				per_level = 2,
				skip_level = 1,
				skip_heading = false,
				icon = "▎",
				highlight = "RenderMarkdownIndent",
			},
			link = {
				enabled = true,
				footnote = { enabled = true, superscript = true, prefix = "", suffix = "" },
				image = "󰥶 ",
				email = "󰀓 ",
				hyperlink = "󰌹 ",
				wiki = {
					icon = "󱗖 ",
					body = function()
						return nil
					end,
					highlight = "RenderMarkdownWikiLink",
				},
				custom = {
					web = { pattern = "^http", icon = "󰖟 " },
					discord = { pattern = "discord%.com", icon = "󰙯 " },
					github = { pattern = "github%.com", icon = "󰊤 " },
					gitlab = { pattern = "gitlab%.com", icon = "󰮠 " },
					google = { pattern = "google%.com", icon = "󰊭 " },
					neovim = { pattern = "neovim%.io", icon = " " },
					reddit = { pattern = "reddit%.com", icon = "󰑍 " },
					stackoverflow = { pattern = "stackoverflow%.com", icon = "󰓌 " },
					wikipedia = { pattern = "wikipedia%.org", icon = "󰖬 " },
					youtube = { pattern = "youtube%.com", icon = "󰗃 " },
				},
				highlight = "RenderMarkdownLink",
			},
			checkbox = {
				custom = {
					important = {
						raw = "[~]",
						rendered = "󰓎 ",
						highlight = "DiagnosticWarn",
					},
				},
			},
			preset = "none",
			max_file_size = 10.0,
			debounce = 100,
			win_options = {
				conceallevel = { default = vim.o.conceallevel, rendered = 3 },
				concealcursor = { default = vim.o.concealcursor, rendered = "" },
			},
			file_types = { "markdown" },
		})

		-- Optional: Remove trailing newline automatically after rendering
		vim.api.nvim_create_autocmd("User", {
			pattern = "RenderMarkdownUpdated",
			callback = function()
				local bufnr = vim.api.nvim_get_current_buf()
				local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
				if #lines > 1 and lines[#lines] == "" then
					vim.api.nvim_buf_set_lines(bufnr, #lines - 1, #lines, false, {})
				end
			end,
		})
	end,
}
