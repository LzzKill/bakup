---@class Package
---@field [1] string
---@field path? string
---@field version? string
---@field config? function | string[]
---@field file? string
---@field dependence ? boolean | function -- Only when it is true or return of function is true, it will be configure.
---@class Package_T : Package
---@field status PackageStatus
---
---@class DownloadOption
---@field app string
---@field arguments? string | string[]
---@class GitOption
---@field depth? integer
---@field branch? string
---@field arguments? string | string[]
---@class DownloaderOption
---@field Downloader? DownloadOption
---@field Git? GitOption
---@field thread boolean
---@class BakupOption
---@field [1] SystemPackageManager
---@field Download? DownloaderOption
---@class File
---@field [1] string
---@field [2]? string
---@field branch? string -- Only git mode need
---@class SystemPackageManager
---@field command string
---@field update string
---@field upgrade? string | boolean
---@field remove string
---@field remove_with_depend string
---@field remove_cache string
---@field download_only string
---@field install string
---@field install_local string
---@field remove_cache_all string?
---
---@class Bakup
---@field option BakupOption
---@field packages BakupPackageManager

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

---@type BakupOption
local BakupOption = {
  Download = {
    Git = {
      depth = 1,
    },
    Downloader = {
      app = "curl",
      arguments = "-O",
    },
  thread = true
  }
}

---@type SystemPackageManager
local pacman = {
  command = "pacman",
  update = "-Syu",
  remove = "-R",
  remove_with_depend = "-Rsu",
  remove_cache = "-Sc",
  download_only = "-Sw",
  install = "-S",
  install_local = "-U",
  remove_cache_all = "-Scc"
}

local M = {}
M.linux = {}



M.linux.arch = pacman
M.linux.maojaro = pacman


M.status = PackageStatus
M.bakup_option = BakupOption
return M
