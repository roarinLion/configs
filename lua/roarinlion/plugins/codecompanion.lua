return {
  -- Add the codecompanion plugin
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required dependency
      "nvim-treesitter/nvim-treesitter", -- Required dependency
    },
    config = function()
      -- Optionally add any configuration for the plugin here
    end,
  },
}
