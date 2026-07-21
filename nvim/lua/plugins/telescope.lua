return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Telescope",
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>",          desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>",           desc = "Live grep" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>",             desc = "Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>",           desc = "Help tags" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>",            desc = "Recent files" },
    { "<leader>fs", "<cmd>Telescope grep_string<cr>",         desc = "Grep word under cursor" },
    { "<leader>fc", "<cmd>Telescope git_commits<cr>",         desc = "Git commits" },
    { "<leader>fG", "<cmd>Telescope git_status<cr>",          desc = "Git status (changed files)" },
  },
  opts = {
    defaults = {
      file_ignore_patterns = { "node_modules", "%.git/", "tmp/", "log/", "public/assets/" },
      layout_strategy = "horizontal",
      layout_config = { preview_width = 0.55 },
    },
    pickers = {
      find_files = { hidden = true },
    },
  },
}
