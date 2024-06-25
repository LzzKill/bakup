---@alias command string[]
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

---@class PackageConfig
---@field loca? boolean
---@field path? string
---@field config? function | command
---@field dependence ? Package[] | boolean -- If it is a package, when that
---package was done, it will be configured; If it is a boolean, when that
---boolean is "true" (or return value of function is "true"), it will be configured
---
---@class Package
---@field [1] string
---@field config? PackageConfig
---@field version? string
---
---@class Package_T : Package
---@field status PackageStatus

---@class PackageOption
---@field maxthreads number
---@field timeout number -- ms
---@field autoclean boolean -- If true, when a thread done it's task(e.g. download), it end or not to do next step.
---@field password string?
---@type PackageOption
local PackageOption = {
  maxthreads = 8,
  timeout = 120,
  autoclean = false,
}

---@class BakupOption
---@field [1] SystemPackageManager
---@field Downloader string?
---@field Git string?
---@field Gitdir string?
---@field PackagesOption PackageOption?
local BakupOption = {}

local M = {}

M.status = PackageStatus
M.package_option = PackageOption
M.bakup_option = BakupOption
return M
