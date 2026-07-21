-- Diffview's auto-refresh autocmd lives in its plugin spec

-- No autoformat-on-save for Ruby/ERB: the team has no formatter convention,
-- and rubocop/erb-format defaults would restyle shared files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "ruby", "eruby" },
  callback = function()
    vim.b.autoformat = false
  end,
})
