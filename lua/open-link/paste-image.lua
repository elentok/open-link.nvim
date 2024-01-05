local h = require("open-link.helpers")
local escape = vim.fn.shellescape

local function verifyWlPaste()
  if h.hasCommand("wl-paste") then
    return true
  end

  vim.notify("wl-paste is missing, please install the 'wl-clipboard' package", vim.log.levels.ERROR)
  return false
end

local function verifyPngPaste()
  if h.hasCommand("pngpaste") then
    return true
  end

  if not h.confirm("pngpaste is missing, run 'brew install pngpaste'?") then
    return false
  end

  vim.fn.system("brew install pngpaste")
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to install pngpaste", vim.log.levels.ERROR)
    return false
  end

  if h.hasCommand("pngpaste") then
    return true
  end

  vim.notify("Install pngpaste but its not found in PATH", vim.log.levels.ERROR)
  return false
end

local function optimizeImage(filepath)
  if h.hasCommand("pngcrush") then
    h.runShell("pngcrush -ow " .. escape(filepath))
  else
    vim.notify("pngcrush is missing, skipping optimization", vim.log.levels.WARN)
  end
end

---@param filepath string
---@return boolean
local function pasteImageToFile(filepath)
  local sys = vim.loop.os_uname().sysname
  if sys == "Darwin" then
    return verifyPngPaste() and h.runShell("pngpaste " .. escape(filepath))
  elseif sys == "Linux" then
    if vim.env.XDG_SESSION_TYPE == "wayland" then
      return verifyWlPaste() and h.runShell("wl-paste -t image/png > " .. escape(filepath))
    else
      return h.runShell("xclip -selection clipboard -t image/png -o > " .. escape(filepath))
    end
  else
    vim.notify("Currently only Mac and Linux are supported", vim.log.levels.ERROR)
    return false
  end
end

local function findNextImageName()
  local basename = vim.fn.expand("%:t:r")
  local index = 1
  local name = basename .. "01"
  while h.fileExists(h.relativeToBuffer(name .. ".png")) do
    index = index + 1
    name = string.format("%s%02d", basename, index)
  end
  return name
end

local function pasteImage()
  vim.ui.input({
    prompt = "Enter image name:",
    default = findNextImageName(),
  }, function(name)
    local filepath = h.relativeToBuffer(name .. ".png")
    if h.fileExists(filepath) and not h.confirm("File already exists, overwrite?") then
      return
    end
    if not pasteImageToFile(filepath) then
      return
    end
    optimizeImage(filepath)
    local link = string.format("![%s.png](%s.png)", name, name)
    vim.api.nvim_put({ link }, "c", true, true)
  end)
end

return pasteImage
