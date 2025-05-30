---@alias LinkExpander fun(string):(string|nil)

---@class OpenLinkConfig
---@field expanders LinkExpander[]
---@field extraLinkPrefixes string[]

---@type OpenLinkConfig
local config = {
  expanders = {},
  extraLinkPrefixes = {},
}

return config
