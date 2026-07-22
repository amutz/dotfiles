-- LazyVim defaults already cover the previous hand-rolled options
-- (2-space indent, smartcase, undofile, system clipboard, etc.)

-- Rails: treat these as noise in :find and friends
vim.opt.wildignore:append({ "*/node_modules/*", "*/tmp/*", "*/log/*", "*/.git/*", "*/public/assets/*" })

-- Prefer a native clipboard (wl-copy against the dcu-mounted Wayland socket,
-- or host tools); fall back to OSC 52 for terminals that honor it (VS Code /
-- Codespaces does, Ptyxis does not).
local has_native_clipboard = (vim.env.WAYLAND_DISPLAY and vim.fn.executable("wl-copy") == 1)
    or (vim.env.DISPLAY and (vim.fn.executable("xclip") == 1 or vim.fn.executable("xsel") == 1))
    or vim.fn.executable("pbcopy") == 1
if not has_native_clipboard then
  vim.g.clipboard = "osc52"
end

-- Soft-wrap long lines (LazyVim disables wrap by default)
vim.opt.wrap = true
vim.opt.linebreak = true -- break at word boundaries, not mid-word
vim.opt.breakindent = true -- wrapped continuation keeps the line's indent
