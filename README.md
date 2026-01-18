# navigation.nvim
Plugin for VSCode like navigation in Neovim

## APIs

| Function                  | Description |
|---------------------------|-------------|
| `navigation.back()`       | Navigates backward through your cursor history. |
| `navigation.forward()`    | Navigates forward through your cursor history. |
| `navigation.record()`     | Records the current cursor position and the destination after a jump. This is essential for building the navigation history. |
| `navigation.toggle()`     | Toggles the `navigation.nvim` plugin on or off. |

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
