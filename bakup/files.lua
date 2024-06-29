local types = require("bakup.types")
local co = coroutine
---@class Downloader
local M = {}

---Return new object. -- NOTE: Need to be changed.
---@param option DownloaderOption
---@param o? Downloader
---@return Downloader
function M:new(option, o)
  local class = o or {}
  setmetatable(class, self)
  self.__index = self
  local cod = Option_c(types.bakup_option.Download, option)
  self.thread = cod.thread
  local cg = { "git clone" }; local cd = {}
  for _, value in pairs(cod.Downloader) do
    if value then
      table.insert(cd, BuildCommand_t(value))
    end
  end
  for key, value in pairs(cod.Git) do
    if value then
      table.insert(cg, BuildCommand_t("--" .. key, value))
    end
  end
  self.command_d = BuildCommand_t(cd)
  self.command_g = BuildCommand_t(cg)
  ---@type table<File>
  self.task_d = {}
  ---@type table<File>
  self.task_g = {}
  return class
end

---Add a git task. -- NOTE: Task to be changed.
---@param file string | File
function M:add_g(file)
  if type(file) == "string" then
    table.insert(self.task_g, { file })
  else
    table.insert(self.task_g, { file })
  end
end

---Add a downloading task -- NOTE: Task to be changed.
---@param file string | File
function M:add_d(file)
  if type(file) == "string" then
    table.insert(self.task_d, { file })
  else
    table.insert(self.task_d, { file })
  end
end

function M:do_d()
  if M.thread then
    local t = {}
    for _, value in ipairs(self.task_d) do
      local m = co.create(function()
        SystemRun(BuildCommand_t(self.command_d, value[1], (value[2] or "")))
      end)
      table.insert(t, m)
      co.resume(m)
      ::code::
      for index, val in pairs(t) do
        if co.status(val) == "dead" then
          table.remove(self.task_d, index)
        end
        if #self.task_d > 0 then goto code end
      end
    end
  else
    for _, value in ipairs(self.task_d) do
      SystemRun(BuildCommand_t(self.command_d, value[1], (value[2] or "")))
    end
  end
end

function M:do_g()
  if M.thread then
    local t = {}
    for _, value in ipairs(self.task_g) do
      local m = co.create(function()
        SystemRun(BuildCommand_t(self.command_g, value[1], (value[2] or ""), (value.branch or "")))
      end)
      table.insert(t, m)
      co.resume(m)
      ::code::
      for index, val in pairs(t) do
        if co.status(val) == "dead" then
          table.remove(self.task_g, index)
        end
        if #self.task_g > 0 then goto code end
      end
    end
  else
    for _, value in ipairs(self.task_g) do
      SystemRun(BuildCommand_t(self.command_g, value[1], (value[2] or "")))
    end
  end
end

function M:deplication()
  local t1 = co.create(function()
    for i = 1, #self.task_d, 1 do
      for j = i + 1, #self.task_d, 1 do
        if self.task_d[i] == self.task_d[j] then
          table.remove(self.task_d, j)
        end
      end
    end
  end)
  local t2 = co.create(function()
    for i = 1, #self.task_g, 1 do
      for j = i + 1, #self.task_g, 1 do
        if self.task_g[i] == self.task_g[j] then
          table.remove(self.task_g, j)
        end
      end
    end
  end)
  co.resume(t1, 1); co.resume(t2, 2)
  ::code::
  local r1 = co.status(t1); local r2 = co.status(t2)
  if r1 == r2 == "dead" then
    return
  end
  goto code
end

return M
