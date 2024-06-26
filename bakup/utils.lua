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

---@param t table
---@param s string
-- Cover table to string and use "s" connect.
TableCover = function(t, s)
  local c = ""
  for _, value in pairs(t) do
    if type(value) == "table" then
      c = c .. TableCover(value, s) .. s
    end
  end
  return c
end


---@param ... string
---@return string
-- It marge all string to one string and use " " connect.
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
  end
  return c
end


---@param ... string
---@return string
-- Auto add "sudo"
BuildCommand_u = function(...)
  if M.root then
    return BuildCommand_t(...)
  else
    return BuildCommand_t("sudo", ...)
  end
end

SystemRun = function(command)
  os.execute(command)
end



if os.getenv("UID") == 0 then
  M.root = true
end
