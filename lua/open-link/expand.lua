local config = require("open-link.config")
local helpers = require("open-link.helpers")

---@param link string
local function expand(link)
  for _, expander in ipairs(config.expanders) do
    local expanded_link = expander(link)

    if expanded_link ~= nil then
      link = expanded_link
    end
  end

  local path_to_file = helpers.findAbsPath(link)
  if path_to_file ~= nil then
    return path_to_file
  end

  return link
end

return expand
