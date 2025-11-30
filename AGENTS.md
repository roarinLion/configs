# Agent Guidelines for Neovim Configuration

## Commands
- **Format code**: `:ConformInfo` to check formatters, `<leader>mp` to format
- **Lint code**: `:Lint` or `<leader>l` to lint current file
- **Update plugins**: `:Lazy update`
- **Check health**: `:checkhealth`
- **Sync plugins**: `:Lazy sync`

## Code Style
- **Language**: Lua (primary), with some Vimscript
- **Formatting**: 2 spaces indentation, use Stylua for Lua files
- **Imports**: Use `local var = require("module")` pattern
- **Naming**: snake_case for variables/functions, PascalCase for modules
- **Error handling**: Use `pcall()` for potentially failing operations
- **Comments**: Minimal comments, prefer self-documenting code
- **Plugin structure**: Return table with plugin spec from plugin files
- **Keymaps**: Use `vim.keymap.set()` with descriptive descriptions
- **Autocmds**: Use `vim.api.nvim_create_autocmd()` with augroups
- **Options**: Use `vim.opt` for global options, `vim.g` for global variables
- **No semicolons**: Lua doesn't require them
- **String quotes**: Use double quotes for consistency
- **Table formatting**: Align keys/values for readability
- **Function definitions**: Use `function()` syntax over `() ->` for clarity