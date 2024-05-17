local expand = require("open-link.expand")

local function extendVimUiOpen()
  local originalOpen = vim.ui.open
  vim.ui.open = function(path)
    return originalOpen(expand(path))
  end
end

return extendVimUiOpen
