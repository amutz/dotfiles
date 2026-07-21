return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewRefresh" },
  config = function()
    require("diffview").setup()

    -- Auto-refresh an open Diffview when nvim regains focus, so external
    -- git operations (commits, checkouts, agent edits) show up automatically.
    local group = vim.api.nvim_create_augroup("DiffviewAutoRefresh", { clear = true })
    vim.api.nvim_create_autocmd("FocusGained", {
      group = group,
      callback = function()
        if require("diffview.lib").get_current_view() ~= nil then
          vim.cmd("DiffviewRefresh")
        end
      end,
    })
  end,
}
