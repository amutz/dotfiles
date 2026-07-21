-- Team doesn't use rubocop: no .rubocop.yml in the repo, so any rubocop run
-- applies stock defaults (Metrics/* noise) and formatting would pollute diffs.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rubocop = { enabled = false },
        ruby_lsp = {
          -- ruby-lsp also runs rubocop diagnostics itself when it's in the bundle
          init_options = { linters = {} },
        },
      },
    },
  },
}
