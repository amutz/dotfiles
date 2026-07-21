-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Basic options
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.undofile = true
vim.opt.clipboard = "unnamedplus"
vim.opt.path:append("**")
vim.opt.wildignore:append({ "*/node_modules/*", "*/tmp/*", "*/log/*", "*/.git/*", "*/public/assets/*" })

-- Load plugins from lua/plugins/
require("lazy").setup("plugins")

-- Diffview keymaps
vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>",        { desc = "Diffview: open" })
vim.keymap.set("n", "<leader>gc", "<cmd>DiffviewClose<cr>",       { desc = "Diffview: close" })
vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>", { desc = "Diffview: repo history" })
vim.keymap.set("n", "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", { desc = "Diffview: file history" })

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

vim.keymap.set("v", "<leader>yl", yank_file_lines, { desc = "Yank file:line(s) of selection" })
vim.keymap.set("n", "<leader>yl", yank_file_lines, { desc = "Yank file:current line" })
