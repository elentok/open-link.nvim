# open-link.nvim

Neovim plugin to open links in a browser (or copy to clipboard when in an SSH
session).

The reason I wrote this plugin is that I wanted to be able to open Jira ticket
IDs and Github pull requests from my notes (or code comments) without writing
the entire URL.

For example, pressing `ge` while standing on MYJIRAPROJ-1234 will open the
ticket in the browser. See example below.

## Bonus feature: create link from image in clipboard

You can use the `:PasteImage` command to paste an image from the clipboard to a
file and add a markdown link to that image (`![file.png](file.png)`).

## Installation

Using [Lazy](https://github.com/folke/lazy.nvim):

```lua
{
  "elentok/open-link.nvim",
  init = function()
    local expanders = require("open-link.expanders")
    require("open-link").setup({
      expanders = {
        -- expands "{user}/{repo}" to the github repo URL
        expanders.github,

        -- expands "format-on-save#15" the issue/pr #15 in the specified github project
        -- ("format-on-save" is the shortcut/keyword)
        expanders.github_issue_or_pr("format-on-save", "elentok/format-on-save.nvim"),

        -- expands "MYJIRA-1234" and "myotherjira-1234" to the specified Jira URL
        expanders.jira("https://myjira.atlassian.net/browse/", { "myjira", "myotherjira"})
      },
    })
  end,
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
    },
    {
      "<Leader>ip",
      "<cmd>PasteImage<cr>",
      desc = "Paste image from clipboard",
    },
  }
}
```
