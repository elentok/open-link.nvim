local h = require("open-link.helpers")
local escape = vim.fn.shellescape

local function findPngPasteScriptPath()
  local scriptPath = h.getScriptPath()
  return scriptPath .. "/../../scripts/pngpaste-mac"
end

---@return string|nil
local function findWlPaste()
  if h.hasCommand("wl-paste") then
    return "wl-paste"
  end

  if h.hasCommand("wl-clip.paste") then
    return "wl-clip.paste"
  end

  vim.notify(
    "wl-paste is missing, please install the 'wl-clipboard' package (or 'wl-clip' via snap)",
    vim.log.levels.ERROR
  )
  return nil
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
local function pasteImageToFileInLinux(filepath)
  if vim.env.XDG_SESSION_TYPE == "wayland" then
    local wlPaste = findWlPaste()
    if wlPaste == nil then
      return false
    end
    return h.runShell(wlPaste .. " -t image/png > " .. escape(filepath))
  end

  return h.runShell("xclip -selection clipboard -t image/png -o > " .. escape(filepath))
end

---@param filepath string
---@return boolean
local function pasteImageToFile(filepath)
  local sys = vim.loop.os_uname().sysname
  if sys == "Darwin" then
    return h.runShell(findPngPasteScriptPath() .. " " .. escape(filepath))
  elseif sys == "Linux" then
    return pasteImageToFileInLinux(filepath)
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
