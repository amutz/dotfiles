-- LazyVim defaults already cover the previous hand-rolled options
-- (2-space indent, smartcase, undofile, system clipboard, etc.)

-- Rails: treat these as noise in :find and friends
vim.opt.wildignore:append({ "*/node_modules/*", "*/tmp/*", "*/log/*", "*/.git/*", "*/public/assets/*" })
