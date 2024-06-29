require("bakup.utils")

local types = require("bakup.types")

---@class Bakup
local M = {}
M.linux = types.linux

---Return new object.
---@param option BakupOption
---@param o? Bakup
---@return Bakup
function M:new(option, o)
  local class = o or {}
  setmetatable(class, self)
  self.__index = self
  self.option = Option_c(types.bakup_option, option)
  self.manager = option[1]
  self.packages = require("bakup.packages"):new()
  self.downloader = require("bakup.files"):new(option.Download)
  return class
end

---@return table<string>
function M:get_packages()
  local list = self.packages.packages_list
  local localpackage = ""
  local webpackage = ""
  for _, value in ipairs(list) do
    if value.path then
      localpackage = localpackage .. value.path .. " "
    else
      if type(value[1]) == "table" then
        webpackage = webpackage .. TableCover(value[1], " ") .. " "
      else
        webpackage = webpackage .. value[1] .. " "
      end
    end
  end
  return {
    localpackage, webpackage
  }
end

---@param packagelist table<Package>
function M:addPackage_list(packagelist)
  for _, value in ipairs(packagelist) do
    self.packages:add(value)
  end
end

---@param gitlist table<File>
function M:addGit_list(gitlist)
  for _, value in ipairs(gitlist) do
    self.downloader:add_g(value)
  end
end

---@param filelist table<File>
function M:addFile_list(filelist)
  for _, value in ipairs(filelist) do
    self.downloader:add_d(value)
  end
end

function M:download_files()
  self.downloader:do_d()
  self.downloader:do_g()
end

function M:install_packages()
  local commands = self:get_packages()
  if commands[1] ~= "" then SystemRun(BuildCommand_u(self.manager.command, self.manager.install_local, commands[1])) end
  if commands[2] ~= "" then SystemRun(BuildCommand_u(self.manager.command, self.manager.install, commands[2])) end
end

function M:download_packages()
  local commands = self:get_packages()[2]
  if commands ~= "" then SystemRun(BuildCommand_u(self.manager.command, self.manager.download_only, commands[2])) end
end

function M:update()
  SystemRun(BuildCommand_u(self.manager.command, self.manager.update))
  if self.manager.upgrade then
    SystemRun(BuildCommand_u(self.manager.command, self.manager.upgrade))
  end
end

function M:config_packages()
  local list = M.packages.packages_list
  for _, value in ipairs(list) do
    if value.dependence then
      local m = type(value.dependence)
      if m == "function" and value.dependence() or m == "boolean" and value.dependence then
        local t = type(value.config)
        if t == "function" then
          value.config()
        elseif t == "string" then
          SystemRun(value.config)
        elseif t == "table" then
          for _, v in pairs(value.config) do SystemRun(BuildCommand_t(v)) end
        end
      end
    end
  end
end

function M:clean()
  SystemRun(BuildCommand_u(self.manager.command, self.manager.remove_cache))
end

return M
