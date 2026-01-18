# navigation.nvim
Plugin for VSCode like navigation in Neovim

## Features

- **Cursor Stack Navigation**: Navigate through your editing history with `back` and `forward` commands, similar to VSCode's "Go Back" and "Go Forward" functionality. This feature records your cursor positions when you make significant jumps (e.g., go to definition, references, or manual jumps).

- **`navigation.record()`**: This function is crucial for building your navigation history. It records both the *origin* (where you were before the jump) and the *destination* (where you landed). To ensure a comprehensive history, you should call `navigation.record()` before any command that makes a significant cursor jump, such as `gd` (go to definition), `gr` (go to references), `C-]` (tag stack), or even custom navigation functions. It can also be called automatically on `CursorMoved` events to capture all movements.

## Usage

### With [wbthomason/packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {"Shresth72/navigation.nvim", tag = "*" } -- stable version
use {"Shresth72/navigation.nvim"}
```

### With [junegunn/vim-plug](https://github.com/junegunn/vim-plug)

```lua
Plug "Shresth72/navigation.nvim", { "tag": "*" } -- stable version
Plug "Shresth72/navigation.nvim"
```

### With [folke/lazy.nvim](https://folke.nvim)

When you provide an `opts` table, `lazy.nvim` automatically calls `require("navigation").setup(opts)`. This is the simplest way to configure the plugin.

```lua
require("lazy").setup({
    {
        "Shresth72/navigation.nvim",
        version = "*", -- optional
        opts = {
            enable = true,
            debug = false,
            keymaps = {
                back = "<M-->",
                forward = "<M-=>",
            }
        },
    },
    -- other plugins
})
```

### Default Keybindings

| Function | Keybinding | Description |
|----------|------------|-------------|
| Back     | `<M-->`   | Navigates backward through your cursor history. |
| Forward  | `<M-=>`   | Navigates forward through your cursor history. |


#### Advanced Usage (with keymaps and custom commands)

If you want to add custom keymaps, override defaults, or integrate `navigation.record()` with other navigation commands, you should provide a `config` function. When you use a `config` function, you must call `setup(opts)` yourself.

```lua
require("lazy").setup({
  {
    "Shresth72/navigation.nvim",
    opts = {
      enable = true,
      debug = false,
      keymaps = {
        back = "<C-o>",
        forward = "<C-i>",
      }
    },
    config = function(_, opts)
      local navigation = require("navigation")
      navigation.setup(opts)

      -- Example keymap for the toggle function
      vim.keymap.set("n", "<leader>nt", navigation.toggle, { desc = "Toggle Navigation" })

      -- Integrate navigation.record() with LSP commands
      vim.keymap.set("n", "gd", function()
        navigation.record()
        vim.lsp.buf.definition()
      end, { desc = "LSP Go to Definition (with Navigation Record)" })

      vim.keymap.set("n", "gr", function()
        navigation.record()
        vim.lsp.buf.references()
      end, { desc = "LSP Go to References (with Navigation Record)" })
    end,
  },
  -- other plugins
})
```
