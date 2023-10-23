local config = require("open-link.config")

---@param link string
local function expand(link)
  for _, expander in ipairs(config.expanders) do
    local expanded_link = expander(link)

    if expanded_link ~= nil then
      link = expanded_link
    end
  end

  return link
end

return expand
