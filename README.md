# navigation.nvim
Plugin for VSCode like navigation in Neovim

## Features
1. Navigate with Alt + -/+, when a navigation action is recorded (like VSCode).
2. Going to definitions records the source and destination.
3. Going to references:
    - Records the source and chosen destination from the quickfix buffer.
    - Also records when another destination is selected from already open quickfix.
4. Records the source and destination, when using `:LineNumber` navigation.

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
        lazy = false,
    },
})
```

### Default Keybindings

| Function             | Keybinding | Description                                                 |
|----------------------|------------|-------------------------------------------------------------|
| Back                 | `<M-->`    | Navigates backward through your cursor history.             |
| Forward              | `<M-=>`    | Navigates forward through your cursor history.              |
| Go To Definition     | `gd`       | Goes to the Definition of the term, and records the action. |
| Go To References     | `gr`       | Goes to the References of the term, and records the action. |

### Exposed Vim Commands

| Command                    | Description                                    |
| -------------------------- | ---------------------------------------------- |
| `:NavigationToggle`        | Toggle `navigation.nvim` on or off.            |
| `:NavigationEnable`        | Enable `navigation.nvim`.                      |
| `:NavigationDisable`       | Disable `navigation.nvim`.                     |
| `:NavigationBack`          | Navigate backward through your cursor history. |
| `:NavigationForward`       | Navigate forward through your cursor history.  |
| `:NavigationDefinition`    | Go to definition and record the navigation.    |
| `:NavigationReferences`    | Go to references and record the navigation.    |
| `:NavigationLine {number}` | Navigate to a line and record the navigation.  |


#### Advanced Usage (with keymaps and custom commands)

If you want to add custom keymaps, override defaults, or integrate `navigation.record()` with other navigation commands, you should provide a `config` function. When you use a `config` function, you must call `setup(opts)` yourself.

```lua
require("lazy").setup({
  {
    "Shresth72/navigation.nvim",
    lazy = false,
    opts = {
      enable = true,
      debug = false,
      keymaps = {
        back = "<C-o>",
        forward = "<C-i>",
        goToDefinition = "gd",
        goToReferences = "gr",
      }
    },
  },
  -- other plugins
})
```
