local M = {}
-- глабальные установки цветовоых схем

function M.setup()
  vim.api.nvim_set_hl(0, "MyHighlightPath", {
    fg = "#ada085",
    ctermfg = 180,
    default = true,
  })

  vim.api.nvim_set_hl(0, "MyHighlightTitle", {
    fg = "#3b77b3",
    bold = true,
    default = true,
  })

  vim.api.nvim_set_hl(0, "MyHighlightFooter", {
    fg = "#2f5e8c",
    default = true,
  })
end

return M

