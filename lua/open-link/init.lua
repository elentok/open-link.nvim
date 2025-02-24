local config = require("open-link.config")
local open = require("open-link.open")
local pasteImage = require("open-link.paste-image")
local extendVimUiOpen = require("open-link.extend-vim-ui-open")

---@class SetupOptions
---@field expanders? LinkExpander[] Replaces all of the expanders
---@field extendVimUiOpen? boolean Wrap vim.ui.open (default = true)

---@param opts SetupOptions
local function setup(opts)
  if opts.expanders ~= nil then
    vim.list_extend(config.expanders, opts.expanders)
  end

  if opts.extendVimUiOpen ~= false then
    extendVimUiOpen()
  end

  vim.api.nvim_create_user_command("OpenLink", function()
    open()
  end, {})

  vim.api.nvim_create_user_command("PasteImage", function()
    pasteImage()
  end, {})
end

---@param ... LinkExpander[]
local function addExpanders(...)
  vim.list_extend(config.expanders, { ... })
end

---@param ... LinkExpander[]
local function prependExpanders(...)
  config.expanders = vim.list_extend({...}, config.expanders)
end

return { setup = setup, open = open, addExpanders = addExpanders, prependExpanders = prependExpanders }
