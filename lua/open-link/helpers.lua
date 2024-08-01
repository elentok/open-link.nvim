---@param filepath string
---@return boolean
local function fileExists(filepath)
  return vim.fn.filereadable(filepath) ~= 0
end

local function hasCommand(cmd)
  return vim.fn.exepath(cmd) ~= ""
end

local function confirm(msg)
  return vim.fn.confirm(msg, "&Yes\n&No") == 1
end

local function runShell(cmd)
  local output = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify(string.format("Command '%s' failed: %s", cmd, output), vim.log.levels.ERROR)
    return false
  end

  return true
end

---@param path string
local function relativeToBuffer(path)
  return vim.fn.resolve(vim.fn.expand("%:p:h") .. "/" .. path)
end

--- If the link is a path relative to the current file that exists,
--- it will return the full path (prefixed with "file://")
---@param link string
local function findAbsPath(link)
  local path = vim.fn.resolve(vim.fn.expand("%:p:h") .. "/" .. link)
  if vim.fn.filereadable(path) then
    return "file://" .. path
  end
end

local function isHttpOrFileLink(link)
  return vim.startswith(link, "http://")
    or vim.startswith(link, "https://")
    or vim.startswith(link, "file://")
end

---@return string
local function getScriptPath()
  local info = debug.getinfo(2, "S")
  local script_path = info.source:sub(2)
  local script_dir = vim.fn.fnamemodify(script_path, ":p:h")
  return script_dir
end

return {
  fileExists = fileExists,
  hasCommand = hasCommand,
  confirm = confirm,
  runShell = runShell,
  relativeToBuffer = relativeToBuffer,
  findAbsPath = findAbsPath,
  isHttpOrFileLink = isHttpOrFileLink,
  getScriptPath = getScriptPath,
}
