local config = require("open-link.config")
local open = require("open-link.open")

---@class SetupOptions
---@field expanders? LinkExpander[] Replaces all of the expanders
---@field addExpanders? LinkExpander[] Adds to the existing expanders

---@param opts SetupOptions
local function setup(opts)
  if opts.expanders ~= nil then
    config.expanders = opts.expanders
  end

  if opts.addExpanders ~= nil then
    vim.list_extend(config.expanders, opts.addExpanders)
  end

  vim.api.nvim_create_user_command("OpenLink", function()
    open()
  end, {})
end

---@param ... LinkExpander[]
local function addExpanders(...)
  vim.list_extend(config.expanders, { ... })
end

return { setup = setup, open = open, addExpanders = addExpanders }
