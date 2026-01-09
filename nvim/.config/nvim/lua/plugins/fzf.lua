return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    files = {
      prompt = 'Files> ',
      -- bind 'i' to enter insert mode in fzf prompt
      fzf_opts = {
        ['--bind'] = 'i:toggle-insert'
      },
    },
  },
  keys = {
    -- normal mode keymap
    { "<leader>ff", function() require("fzf-lua").files() end, mode = "n", desc = "Find Files" },
  },
}
