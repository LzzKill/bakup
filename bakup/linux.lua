---@class SystemPackageManager
---@field command string
---@field update string
---@field upgrade string | boolean
---@field remove string
---@field remove_with_depend string
---@field remove_cache string
---@field doanload_only string
---@field install string
---@field install_local string
---@field remove_cache_all string?
---


local M = {}

---@type SystemPackageManager
M.pacman = {
  command = "pacman",
  update = "-Syu",
  upgrade = false,
  remove = "-R",
  remove_with_depend = "-Rsu",
  remove_cache = "-Sc",
  doanload_only = "-Sw",
  install = "-S",
  install_local = "-U",
  remove_cache_all = "-Scc"
}


M.arch = M.pacman -- I use Arch, btw

M.maojaro = M.pacman


return M
