# lazyrex.nvim

Open one stateful LazyGit floating window per Neovim instance in [Rex](https://www.superlogical.com/rex/).

## What it does

`setup()` registers the `:Lazyrex` user command. It does not modify your Rex configuration.

The command uses `rex do` to run the bundled scripts in this plugin's `rex/` directory. Rex makes the current session and pane available to those scripts, so no Rex action or generated configuration is required.

- `rex/lazygit.lua` creates or restores the LazyGit floating layer.
- `rex/edit.lua` opens a selected file in the originating Neovim instance and minimizes that layer.
- `rex/lazygit.yml` tells LazyGit to invoke `edit.lua`.

`:Lazyrex` opens LazyGit for the current Rex pane's working directory. Selecting a file opens it in the Neovim instance that started LazyGit, then minimizes the float without stopping LazyGit. Run `:Lazyrex` again to restore the same float and its state.

## Requirements

- Neovim 0.10+; its `nvim` executable must be available on Rex's `PATH` for file editing
- Rex and the `rex` CLI
- LazyGit

Neovim must be running inside a Rex terminal for `:Lazyrex` to open the float.

## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "omenlog/lazyrex",
  config = function()
    require("lazyrex").setup()
  end,
}
```

## Configuration

```lua
require("lazyrex").setup({
  rex_path = "rex",
  bounds = { 0.2, 0.2, 0.7, 0.7 },
  lazygit_command = { "lazygit" },
})

-- Optional: choose your own mapping in your Neovim configuration.
vim.keymap.set("n", "<leader>g", "<cmd>Lazyrex<CR>", { desc = "Open LazyGit in Rex" })
```

`lazygit_command` defaults to `{ "lazygit" }`. Set it to a shell command when LazyGit
requires shell initialization for its child processes, such as Node version-manager setup:

```lua
require("lazyrex").setup({
  lazygit_command = { "zsh", "-ic", "exec lazygit" },
})
```

## Health check

Run `:checkhealth lazyrex` to verify the `rex` and `lazygit` executables.
