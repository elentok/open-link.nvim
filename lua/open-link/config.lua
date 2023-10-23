---@class RegexLinkExpander
---@field pattern string
---@field replacement string
--
---@alias FnLinkExpander fun(string):string

---@alias LinkExpander FnLinkExpander|RegexLinkExpander

---@class OpenLinkConfig
---@field expanders LinkExpander[]

---@type OpenLinkConfig
local config = {
  expanders = {},
}

return config
