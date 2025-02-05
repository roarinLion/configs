return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local transform_mod = require("telescope.actions.mt").transform_mod

    local trouble = require("trouble")
    local trouble_telescope = require("trouble.sources.telescope")

    -- Custom action to open trouble quickfix list
    local custom_actions = transform_mod({
      open_trouble_qflist = function(prompt_bufnr)
        actions.send_selected_to_qflist(prompt_bufnr) -- Send to quickfix list first
        trouble.toggle("quickfix") -- Then toggle trouble quickfix
      end,
    })

    local function find_and_replace(prompt_bufnr)
      local current_entry = action_state.get_selected_entry()
      if not current_entry then
        return
      end

      local search_text = current_entry.value
      local replace_text = vim.fn.input("Replace with: ")
      if replace_text == "" then
        return
      end

      vim.fn.system(
        string.format('rg -l "%s" | xargs sed -i "" -e "s/%s/%s/g"', search_text, search_text, replace_text)
      )

      actions.close(prompt_bufnr)
      vim.cmd("Telescope live_grep")
    end

    telescope.setup({
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-q>"] = custom_actions.open_trouble_qflist,
            ["<C-t>"] = trouble_telescope.open,
            ["<C-r>"] = find_and_replace,
          },
        },
      },
    })

    telescope.load_extension("fzf")

    local keymap = vim.keymap
    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
  end,
}
