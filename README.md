# open-link.nvim

Neovim plugin to open links in a browser (or copy to clipboard when in an SSH
session).

The reason I wrote this plugin is that I wanted to be able to open Jira ticket
IDs and Github pull requests from my notes (or code comments) without writing
the entire URL.

For example, pressing `ge` while standing on MYJIRAPROJ-1234 will open the
ticket in the browser. This is done by specifying a link expander:

```lua
opts = {
  expanders = {
    {
      pattern = "^MYJIRAPROJ-",
      replacement = "https://myjira.jira.com/MYJIRAPROJ-",
    },
    {
      pattern = "^format-on-save#",
      replacement = "https://github.com/elentok/format-on-save.nvim/pull/",
    }
  }
}
```

## Installation

Using [Lazy](https://github.com/folke/lazy.nvim):

```lua
{
  "elentok/open-link.nvim",
  opts = {},
  cmd = { "OpenLink" },
  dependencies = {
    "ojroques/nvim-osc52",
  },
  keys = {
    {
      "ge",
      function()
        require("open-link").open()
      end,
      desc = "Open the link under the cursor"
    }
  }
}
```
