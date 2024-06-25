require("bakup.utils")

local types = require("bakup.types")

---@class Bakup
---@field option BakupOption
---@field packages BakupPackageManager
local M = {}

function M.init()
  local uid
  uid = os.getenv("UID")
  BuildCommand_c(uid)
end

---@param option BakupOption
---@return Bakup
function M:new(option, o)
  local class = o or {}
  setmetatable(class, self)
  self.__index = self
  self.option = Option_c(types.bakup_option, option)
  self.manager = option[1]
  self.packages = require("bakup.packages"):new(option.PackagesOption)
  return class
end

function M:install_packages()
  --local package
  local l = self:getPackages().packages_list
  local lcommand = ""
  local icommand = ""
  for _, value in ipairs(l) do
    if value.config and value.config.loca then
      lcommand = lcommand .. value.config.path .. " "
    else
      icommand = icommand .. value[1] .. " "
    end
  end
  if lcommand ~= "" then SystemRun(BuildCommand_u(self.manager.command, self.manager.install_local, lcommand)) end
  if icommand ~= "" then SystemRun(BuildCommand_u(self.manager.command, self.manager.install, icommand)) end
end

function M:update()
  SystemRun(BuildCommand_u(self.manager.command, self.manager.update))
  if self.manager.upgrade then
    SystemRun(BuildCommand_u(self.manager.command, self.manager.upgrade))
  end
end

function M:getPackages() return self.packages end

return M
