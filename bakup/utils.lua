local M = {
  root = false
}

---@param option table
---@param option_n table
---@return table
Option_c = function(option, option_n)
  if not option then return option_n end

  local o = {}
  for i, j in ipairs(option) do
    o[i] = option_n[i] or j
  end
  return o
end

BuildCommand = function()

end
TableCover = function(t, s)
  local c = ""
  for _, value in pairs(t) do
    if type(value) == "table" then
      c = c .. TableCover(value) .. s
    end
  end
  return c
end

BuildCommand_t = function(...)
  local c = ""
  if next({ ... }) then
    for i = 1, select("#", ...) do
      local s = select(i, ...)
      if type(s) == "table" then
        c = c .. TableCover(s, " ")
      else
        c = c .. s .. " "
      end
    end
    return c
  else
    return nil
  end
end

BuildCommand_u = function(...)
  if M.root then
    return BuildCommand_t(...)
  else
    return BuildCommand_t("sudo", ...)
  end
end

BuildCommand_c = function(uid)
  if uid == 0 then
    M.root = true
  end
end

SystemRun = function(command)
  os.execute(command)
end
