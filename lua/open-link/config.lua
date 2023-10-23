---@alias LinkExpander fun(string):(string|nil)

---@class OpenLinkConfig
---@field expanders LinkExpander[]

---@type OpenLinkConfig
local config = {
  expanders = {},
}

return config
