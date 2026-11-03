# lazyrex.nvim

Open one stateful LazyGit floating window per Neovim instance in [Rex](https://www.superlogical.com/rex/).

## What it does

`setup()` registers the `:Lazyrex` user command. It does not modify your Rex configuration.

The command uses `rex do` to run the bundled scripts in this plugin's `rex/` directory. Rex makes the current session and pane available to those scripts, so no Rex action or generated configuration is required.

`:Lazyrex` opens LazyGit for the current Rex pane's working directory. For a continuous edit-and-Git flow, lazyrex overrides LazyGit's default `q` quit binding: selecting a file or pressing `q` minimizes the float while LazyGit keeps running. Run `:Lazyrex` again to restore the same process and state without restarting the configured command or shell initialization. Use `<C-q>` to quit LazyGit completely; the next `:Lazyrex` starts a new instance.

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
  lazygit_command = { "zsh", "-ic", "exec lazygit" },
})

-- Optional: choose your own mapping in your Neovim configuration.
vim.keymap.set("n", "<leader>g", "<cmd>Lazyrex<CR>", { desc = "Open LazyGit in Rex" })
```

`lazygit_command` is passed directly to the Rex terminal, so it can be any command that starts LazyGit. It defaults to `{ "zsh", "-ic", "exec lazygit" }`, which loads shell initialization before starting LazyGit.

## Health check

Run `:checkhealth lazyrex` to verify the `rex` and `lazygit` executables.
