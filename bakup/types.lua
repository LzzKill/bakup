---@alias command string[]
---@class Package
---@field [1] string
---@field loca? boolean
---@field path? string
---@field version? string
---@field config? function | command
---@field file? string
---@field dependence ? boolean | function -- Only when it is true or return of function is true, it will be configure.
---@class Package_T : Package
---@field status PackageStatus

---@class BakupOption
---@field [1] SystemPackageManager
---@field Downloader string?
---@field Git string?
---@field Gitdir string?

---@class SystemPackageManager
---@field command string
---@field update string
---@field upgrade string | boolean
---@field remove string
---@field remove_with_depend string
---@field remove_cache string
---@field download_only string
---@field install string
---@field install_local string
---@field remove_cache_all string?
---

---@enum PackageStatus
local PackageStatus = {
  uninstalled = 1,
  downloading = 2,
  downloaded = 3,
  done = 4
}

---@enum PackageEvent
local PackageEvent = {
  uninstalled = 1,
  downloaded = 2,
  done = 3
}


local M = {}

---@type SystemPackageManager
M.linux.pacman = {
  command = "pacman",
  update = "-Syu",
  upgrade = false,
  remove = "-R",
  remove_with_depend = "-Rsu",
  remove_cache = "-Sc",
  download_only = "-Sw",
  install = "-S",
  install_local = "-U",
  remove_cache_all = "-Scc"
}


M.linux.arch = M.pacman
M.linux.maojaro = M.pacman
---@type BakupOption
local BakupOption = {}

M.status = PackageStatus
M.bakup_option = BakupOption
return M
