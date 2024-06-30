local io = io

---@class Data
local M = {}

---Return new object.
---@param option string
---@param o? Data
---@return Data
function M:new(option, o)
  local class = o or {}
  setmetatable(class, self)
  self.__index = self
  local f = io.open(option, "r+")
  if not f then f = io.open(option, "w+") end
  self.data = {}
  local value = f:read("*line")
  while value do
    local t = {}
    local m = string.gsub(value, "[:]+", function(w)
      table.insert(t, w)
    end)
    self.data[t[1]] = t[2]
  end
  self.f = f
  return class
end

---Get key data.
---@param k string
---@return string
function M:getData(k)
  return self.data[k]
end

---Set data
---@param k string
---@param v string
function M:setData(k, v)
  self.data[k] = v
end

function M:save()
  self.f:seek("set")
  local m = ""
  for key, value in pairs(self.data) do
    m = m..key..":"..value.."\n"
  end
  self.f:write(m)
  self.f:flush()
end

function M:close()
  self:save()
  self.f:close()
end

return M
