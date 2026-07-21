local map = vim.keymap.set

-- Muscle-memory picker maps from the pre-LazyVim config
-- (<leader>ff / fb / fr already match LazyVim defaults)
map("n", "<leader>fg", function() Snacks.picker.grep() end, { desc = "Grep (live)" })
map("n", "<leader>fs", function() Snacks.picker.grep_word() end, { desc = "Grep word under cursor" })
map("n", "<leader>fc", function() Snacks.picker.git_log() end, { desc = "Git commits" })
map("n", "<leader>fG", function() Snacks.picker.git_status() end, { desc = "Git status (changed files)" })
map("n", "<leader>fh", function() Snacks.picker.help() end, { desc = "Help tags" })

-- Diffview (overrides LazyVim's <leader>gd git-diff picker)
map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Diffview: open" })
map("n", "<leader>gc", "<cmd>DiffviewClose<cr>", { desc = "Diffview: close" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>", { desc = "Diffview: repo history" })
map("n", "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", { desc = "Diffview: file history" })

-- Yank the file path + selected line range as "path:start-end" to the clipboard.
-- Works inside Diffview (resolves the real path via its API) and in normal buffers.
local function yank_file_lines()
  local path

  local ok, lib = pcall(require, "diffview.lib")
  if ok then
    local view = lib.get_current_view()
    if view then
      local file = view.cur_entry or (view.infer_cur_file and view:infer_cur_file())
      if file and file.path then
        path = file.path -- already relative to the git root
      end
    end
  end

  if not path then
    path = vim.fn.fnamemodify(vim.fn.expand("%"), ":.")
  end

  local s, e = vim.fn.line("v"), vim.fn.line(".")
  if s > e then s, e = e, s end

  local ref = (s == e) and string.format("%s:%d", path, s)
                        or string.format("%s:%d-%d", path, s, e)
  vim.fn.setreg("+", ref)
  vim.notify("Copied: " .. ref)
end

map("v", "<leader>yl", yank_file_lines, { desc = "Yank file:line(s) of selection" })
map("n", "<leader>yl", yank_file_lines, { desc = "Yank file:current line" })
