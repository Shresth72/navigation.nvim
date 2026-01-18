# navigation.nvim
Plugin for VSCode like navigation in Neovim

## Usage

You can setup the plugin with the following code:

```lua
require("navigation").setup()
```

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

### With [folke/lazy.nvim](https://github.com/folke/lazy.nvim)

When you provide an `opts` table, `lazy.nvim` automatically calls `require("navigation").setup(opts)`. This is the simplest way to configure the plugin.

```lua
require("lazy").setup({
    {
        "Shresth72/navigation.nvim",
        version = "*", -- optional
        opts = {
            enable = true,
            debug = false,
        },
    },
    -- other plugins
})
```

#### Advanced Usage (with keymaps)

If you want to add custom keymaps or more complex setup logic, you should provide a `config` function. When you use a `config` function, you must call `setup(opts)` yourself.

```lua
require("lazy").setup({
  {
    "Shresth72/navigation.nvim",
    opts = {
      enable = true,
      debug = false,
    },
    config = function(_, opts)
      local navigation = require("navigation")
      navigation.setup(opts)

      -- Example keymap for the toggle function
      vim.keymap.set("n", "<leader>nt", navigation.toggle, { desc = "Toggle Navigation" })
    end,
  },
  -- other plugins
})
```
