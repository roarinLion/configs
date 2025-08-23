return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim",                   opts = {} },
  },
  config = function()
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    -- Enable LSP capabilities for autocompletion
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change diagnostic signs in gutter
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticSign" .. type, numhl = "" })
    end

    -- Attach common keymaps when an LSP server attaches to a buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }
        local keymap = vim.keymap

        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", { desc = "LSP References", unpack(opts) })
        keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration", unpack(opts) })
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { desc = "LSP Definitions", unpack(opts) })
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", { desc = "LSP Implementations", unpack(opts) })
        keymap.set(
          "n",
          "gt",
          "<cmd>Telescope lsp_type_definitions<CR>",
          { desc = "LSP Type Definitions", unpack(opts) }
        )

        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action", unpack(opts) })
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename Symbol", unpack(opts) })

        keymap.set(
          "n",
          "<leader>D",
          "<cmd>Telescope diagnostics bufnr=0<CR>",
          { desc = "Buffer Diagnostics", unpack(opts) }
        )
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line Diagnostics", unpack(opts) })
        keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic", unpack(opts) })
        keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic", unpack(opts) })

        keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation", unpack(opts) })
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", { desc = "Restart LSP", unpack(opts) })
      end,
    })

    -- Common servers to install manually and configure
    local servers = {
      "ts_ls",
      "html",
      "cssls",
      "tailwindcss",
      "svelte",
      "lua_ls",
      "graphql",
      "emmet_ls",
      "prismals",
      "pyright",
      "gopls",
    }

    -- Generic setup for most servers
    for _, server in ipairs(servers) do
      lspconfig[server].setup({ capabilities = capabilities })
    end

    -- Svelte (with on_save typescript reload)
    lspconfig["svelte"].setup({
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePost", {
          pattern = { "*.js", "*.ts" },
          callback = function(ctx)
            client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
          end,
        })
      end,
    })

    -- GraphQL (extra filetypes)
    lspconfig["graphql"].setup({
      capabilities = capabilities,
      filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
    })

    -- Emmet
    lspconfig["emmet_ls"].setup({
      capabilities = capabilities,
      filetypes = {
        "html",
        "typescriptreact",
        "javascriptreact",
        "css",
        "sass",
        "scss",
        "less",
        "svelte",
      },
    })

    -- Lua with Neovim-specific settings
    lspconfig["lua_ls"].setup({
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          completion = {
            callSnippet = "Replace",
          },
        },
      },
    })
  end,
}
