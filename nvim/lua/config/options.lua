-- LazyVim defaults already cover the previous hand-rolled options
-- (2-space indent, smartcase, undofile, system clipboard, etc.)

-- Rails: treat these as noise in :find and friends
vim.opt.wildignore:append({ "*/node_modules/*", "*/tmp/*", "*/log/*", "*/.git/*", "*/public/assets/*" })

-- Soft-wrap long lines (LazyVim disables wrap by default)
vim.opt.wrap = true
vim.opt.linebreak = true -- break at word boundaries, not mid-word
vim.opt.breakindent = true -- wrapped continuation keeps the line's indent
