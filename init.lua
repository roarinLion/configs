-- Load configs first
require("roarinlion.core")
require("roarinlion.lazy")

-- Defer highlight tweaks until after colorscheme loads
vim.defer_fn(function()
  -- Enable syntax folding
  vim.opt.foldmethod = "syntax"
  vim.opt.foldenable = true
  vim.opt.foldlevel = 99

  -- Enable cursor line
  vim.opt.cursorline = true

  -- Highlight overrides
  vim.api.nvim_set_hl(0, "Folded", { bg = "#3f05aa", fg = "#a6adc8" })
  vim.api.nvim_set_hl(0, "FoldColumn", { bg = "#3f05aa", fg = "#a6adc8" })
end, 50)
