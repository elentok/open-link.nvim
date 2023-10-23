local config = require("open-link.config")
local open = require("open-link.open")

---@class SetupOptions
---@field expanders? LinkExpander[]
---@field appendExpanders? LinkExpander[]

---@param opts SetupOptions
local function setup(opts)
  if opts.expanders ~= nil then
    config.expanders = opts.expanders
  end

  if opts.appendExpanders ~= nil then
    vim.list_extend(config.expanders, opts.appendExpanders)
  end

  vim.api.nvim_create_user_command("OpenLink", function()
    open()
  end, {})
end

return { setup = setup, open = open }
