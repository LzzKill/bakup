local types = require("bakup.types")

---@class BakupPackageManager
local M = {}

---@type Package[]
M.packages_list = {}

---@param package Package
function M:add(package)
  table.insert(self.packages_list, package)
  return self
end

---@param packagelist table<Package>
function M:addlist(packagelist)
  for _, value in ipairs(packagelist) do
    self:add(value)
  end
end

function M:duplication()
  for i = 1, #self.packages_list, 1 do
    for j = i + 1, #self.packages_list, 1 do
      if self.packages_list[i] == self.packages_list[j] then
        table.remove(self.packages_list, j)
      end
    end
  end
end

function M:download()

end

function M:update()
end

function M:install()
  M:duplication()
  -- local option = self.option
end

---@param option PackageOption
function M:new(option, o)
  local class = o or {}
  setmetatable(class, self)
  self.__index = self
  self.option = Option_c(types.package_option, option)
  return class
end

return M
