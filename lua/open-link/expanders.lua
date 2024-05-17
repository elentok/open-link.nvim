local function regex(pattern, replacement)
  return function(link)
    return vim.fn.substitute(link, pattern, replacement, "")
  end
end

local github_regex = vim.regex("\\v^[a-zA-Z0-9_-]+/[.a-zA-Z0-9_-]+$")

---@param link string
---@return string|nil
local function github(link)
  if github_regex:match_str(link) then
    return "https://github.com/" .. link
  end
end

---@param base_url string
---@param prefixes string[]
---@return LinkExpander
local function jira(base_url, prefixes)
  local re_str = "\\v\\c^(" .. table.concat(prefixes, "|") .. ")-\\d+$"
  local re = vim.regex(re_str)

  return function(link)
    if re:match_str(link) then
      return base_url .. link
    end
  end
end

---@param keyword string
---@param github_project string
---@return LinkExpander
local function github_issue_or_pr(keyword, github_project)
  return function(link)
    return vim.fn.substitute(
      link,
      "\\v\\c^" .. keyword .. "#(\\d+)",
      "https://github.com/" .. github_project .. "/pull/\\1",
      ""
    )
  end
end

-- Expand ~/path/to/file to file://{HOME}/path/to/file
local function homedir()
  return function(link)
    if vim.startswith(link, "~") then
      return "file://" .. os.getenv("HOME") .. link:sub(2)
    end
  end
end

return {
  regex = regex,
  github = github,
  jira = jira,
  github_issue_or_pr = github_issue_or_pr,
  homedir = homedir,
}
