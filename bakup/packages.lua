---@class BakupPackageManager
local M = {}
---@type table<Package>
M.packages_list = {}

---Add a package
---@param package Package
function M:add(package)
  table.insert(self.packages_list, package)
  return self
end
---Remove deplication -- TODO: Fix algorithm.
function M:duplication()
  for i = 1, #self.packages_list, 1 do
    for j = i + 1, #self.packages_list, 1 do
      if self.packages_list[i] == self.packages_list[j] then
        table.remove(self.packages_list, j)
      end
    end
  end
end

---Return new object
---@param o? BakupPackageManager
---@return BakupPackageManager
function M:new(o)
  local class = o or {}
  setmetatable(class, self)
  self.__index = self
  return class
end

return M
