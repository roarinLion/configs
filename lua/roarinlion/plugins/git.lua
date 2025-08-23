return {
  -- Neogit: Git UI like Magit
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim", -- for diffs, log views, file history
    },
    keys = {
      { "<leader>gg", function() require("neogit").open() end, desc = "Open Neogit" },
      { "<leader>gl", "<cmd>DiffviewFileHistory %<CR>",        desc = "File history (current file)" },
      { "<leader>gL", "<cmd>DiffviewFileHistory<CR>",          desc = "Repo history" },
    },
    config = function()
      require("neogit").setup({
        integrations = {
          diffview = true, -- enable diffview integration
        },
        signs = {
          section = { "", "" }, -- open/closed
          item = { "", "" },
          hunk = { "", "" },
        },
        disable_commit_confirmation = true, -- skip 'Are you sure?' on commit
        kind = "tab",                       -- open Neogit in a tab (can be "split" or "vsplit" or "tab")
      })
    end,
  },

  -- Diffview: Enhanced Git diffs and history
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>",  desc = "Open Git diff view" },
      { "<leader>gD", "<cmd>DiffviewClose<CR>", desc = "Close Git diff view" },
    },
    config = true,
  },
}
