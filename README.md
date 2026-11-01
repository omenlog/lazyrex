# lazyrex.nvim

Open one stateful LazyGit floating window per Neovim instance in [Rex](https://www.superlogical.com/rex/).

## What it does

`setup()` installs the Rex integration automatically:

- writes generated `init.lua`, `lazygit.yml`, and `lazygit-edit` files under `~/.config/rex/lazyrex/`;
- adds `require("lazyrex")` to `~/.config/rex/init.lua` if it is missing;
- reloads Rex when the `rex` CLI is available.

`<leader>g` opens LazyGit for the current Rex pane's working directory. Selecting a file opens it in the Neovim instance that started LazyGit, then minimizes the float without stopping LazyGit. Press `<leader>g` again to restore the same float and its state.

## Requirements

- Neovim 0.10+
- Rex and the `rex` CLI
- LazyGit
- `jq` (used by the generated Rex helper)

Neovim must be running inside a Rex terminal for `<leader>g` to open the float.

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
  key = "<leader>g",
  rex_path = "rex",
  bounds = { 0.2, 0.2, 0.7, 0.7 },
})
```

The files generated under `~/.config/rex/` are owned by this plugin. Configure the plugin through `setup()` rather than editing those generated files.

## Health check

Run `:checkhealth lazyrex` to verify the Rex configuration directory, generated `~/.config/rex/lazyrex/` integration directory and files, and the `lazygit` executable.
