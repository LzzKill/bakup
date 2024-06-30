---@class PackageManager
local M = {}
local types = require("./bakup.types")
M.linux = types.linux
require("./bakup.utils")

---Return new object.
---@param option PackageManagerOption
---@param o? PackageManager
---@return PackageManager
function M:new(option, o)
  local class = o or {}
  setmetatable(class, self)
  self.__index = self
  self.option = option
  ---@type table<Package_S>
  self.packages = {}
  -- self.data = require("./data"):new(option.data or "data")
  return class
end

---Add a new package
---@param package Package_S
function M:append(package)
  local p = package
  -- if type(package[1]) == "table" then
  --   p.status = {}
  --   for _, value in ipairs(package[1]) do
  --     table.insert(p.status, self.data:getData(value) or "1")
  --   end
  -- else
  --   p.status = self.data:getData(package[1]) or "1"
  -- end
  table.insert(self.packages, p)
end

function M:install()
  for _, value in ipairs(self.packages) do
    local t = type(value[1]); local cmd
    if t == "table" then
      cmd = BuildCommand_t(self.option[1].command, self.option[1].install, value[1])
    else
      cmd = BuildCommand_t(self.option[1].command, self.option[1].install, value)
    end
    if self.option[1].root then
      SystemRun(BuildCommand_u(cmd))
    else
      SystemRun(cmd)
    end

    -- if value.download then
    --   for _, v in ipairs(value.download) do
    --     SystemRun(BuildCommand_t(self.command_d, v[1], (v[2] or "")))
    --   end
    -- end
    if value.git then
      for _, v in ipairs(value.git) do
        SystemRun(BuildCommand_t("git clone", v[1], (v[2] or ""), BuildCommand_t(v.option)))
      end
    end
    local dependence_t = type(value.dependence)
    if (dependence_t == "function" and value.dependence()) or (dependence_t == "boolean" and value.dependence) then
      local config_t = type(value.config)
      if config_t == "function" then
        value.config()
      elseif config_t == "table" then
        for _, v in ipairs(value.config) do
          BuildCommand_t(v)
        end
      end
    end
  end
end

return M
