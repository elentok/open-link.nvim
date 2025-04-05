local expand = require("open-link.expand")
local helpers = require("open-link.helpers")

---@class FailureCallbackArgs
---@field message? string

---@class OpenLinkOptions
---@field success_callback? fun()
---@field failure_callback? fun(args: FailureCallbackArgs)

---@param command string
---@param link string
---@param opts OpenLinkOptions
local function exec(command, link, opts)
  opts = opts or {}

  vim.fn.jobstart({ command, link }, {
    on_exit = function(_, exitcode, _)
      if exitcode == 0 then
        if opts.success_callback then
          opts.success_callback()
        else
          vim.notify("Link opened.")
        end
      else
        local message = 'Error opening link with "' .. command .. " " .. link .. '"'

        if opts.failure_callback then
          opts.failure_callback({ message = message })
        else
          vim.notify(message, vim.log.levels.ERROR)
        end
      end
    end,
  })
end

---@param link string
---@param opts? OpenLinkOptions
---@return false|nil # when it fails to find a link returns false
local function browse(link, opts)
  opts = opts or {}

  if vim.env.SSH_TTY ~= nil then
    vim.fn.setreg("*", link)
    vim.fn.setreg("+", link)

    if opts.success_callback then
      opts.success_callback()
    else
      vim.notify("Link copied to clipboard.")
    end
  elseif vim.fn.has("wsl") == 1 then
    exec("explorer.exe", link, opts)
  elseif vim.fn.has("macunix") == 1 then
    exec("open", link, opts)
  else
    exec("xdg-open", link, opts)
  end
end

---@param link? string
---@param opts? OpenLinkOptions
local function open(link, opts)
  opts = opts or {}

  if link == nil then
    link = vim.fn.expand("<cfile>")
  end

  if vim.regex("^\\s*$"):match_str(link) then
    local message = "No link was found at the cursor."

    if opts.failure_callback then
      opts.failure_callback({ message = message })
    else
      vim.notify(message, vim.log.levels.WARN)
    end

    return false
  end

  link = expand(link)

  if not helpers.isHttpOrFileLink(link) then
    link = "http://" .. link
  end

  browse(link, opts)
end

return open
