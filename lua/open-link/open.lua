local expand = require("open-link.expand")

local function is_http_or_file_link(link)
  return vim.startswith(link, "http://")
    or vim.startswith(link, "https://")
    or vim.startswith(link, "file://")
end

---@param command string
---@param link string
local function exec(command, link)
  vim.fn.jobstart({ command, link }, {
    on_exit = function(_, exitcode, _)
      if exitcode == 0 then
        vim.notify("Link opened.")
      else
        vim.notify(
          'Error opening link with "' .. command .. " " .. link .. '"',
          vim.log.levels.ERROR
        )
      end
    end,
  })
end

---@param link string
local function browse(link)
  if vim.env.SSH_TTY ~= nil then
    vim.notify("Link copied to clipboard.")
    require("osc52").copy()
  elseif vim.fn.has("wsl") == 1 then
    exec("explorer.exe", link)
  elseif vim.fn.has("macunix") == 1 then
    exec("open", link)
  else
    exec("xdg-open", link)
  end
end

--- If the link is a path relative to the current file that exists,
--- it will return the full path (prefixed with "file://")
---@param link string
local function find_abs_path(link)
  local path = vim.fn.resolve(vim.fn.expand("%:p:h") .. "/" .. link)
  if vim.fn.filereadable(path) then
    return "file://" .. path
  end
end

---@param link? string
local function open(link)
  if link == nil then
    link = vim.fn.expand("<cfile>")
  end

  if vim.regex("^\\s*$"):match_str(link) then
    vim.notify("No link was found at the cursor.", vim.log.levels.WARN)
    return
  end

  link = expand(link)

  if not is_http_or_file_link(link) then
    local path_to_file = find_abs_path(link)
    if path_to_file ~= nil then
      link = path_to_file
    else
      link = "http://" .. link
    end
  end

  browse(link)
end

return open
