-- LazyVim defaults already cover the previous hand-rolled options
-- (2-space indent, smartcase, undofile, system clipboard, etc.)

-- Rails: treat these as noise in :find and friends
vim.opt.wildignore:append({ "*/node_modules/*", "*/tmp/*", "*/log/*", "*/.git/*", "*/public/assets/*" })

-- Devcontainers have no clipboard tool or display server, so tunnel yanks
-- to the host clipboard through the terminal via OSC 52. Only as fallback:
-- with a real provider (host wl-copy etc.) native is better, since OSC 52
-- paste support varies by terminal.
if vim.fn.executable("wl-copy") == 0 and vim.fn.executable("xclip") == 0
    and vim.fn.executable("xsel") == 0 and vim.fn.executable("pbcopy") == 0 then
  vim.g.clipboard = "osc52"
end

-- Soft-wrap long lines (LazyVim disables wrap by default)
vim.opt.wrap = true
vim.opt.linebreak = true -- break at word boundaries, not mid-word
vim.opt.breakindent = true -- wrapped continuation keeps the line's indent
