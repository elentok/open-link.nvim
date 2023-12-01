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

return {
  fileExists = fileExists,
  hasCommand = hasCommand,
  confirm = confirm,
  runShell = runShell,
  relativeToBuffer = relativeToBuffer,
}
