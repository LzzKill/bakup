---@class File
---@field [1] string
---@field [2]? string
---@field branch? string -- Only git mode need

---@class GitInfo
---@field [1] string
---@field [2]? string
---@field option string | table<string>

---@class Package
---@field [1] string | table<string>
--@field path? File
--@field version? string
---@field dependence? function | boolean
---@field command? table<string> | string
---@field git? table<GitInfo>
---@field config? function | table<string>
---@class Package_S: Package
---@field status? PackageStatus | table<PackageStatus>

---@class DownloadOption
---@field app string
---@field arguments string | table<string>
---@class GitOption
---@field depth? integer
---@field branch? string
---@field arguments? string | table<string>

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
---@field root boolean

---@class PackageManagerOption
---@field [1] SystemPackageManager
---@field data? string

---@class Data
---@field file string

---@enum PackageStatus
local PackageStatus = { uninstall = "1", installed = "2", downloaded = "3", only_downloaded = "4" }
---@type DownloadOption
local DownloadOption = { app = "curl", arguments = "-O" }
---@type GitOption
local GitOption = { depth = 1 }

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
  remove_cache_all = "-Scc",
  root = true
}

local M = {}
M.linux = {}

M.linux.pacman = pacman

M.linux.arch = pacman
M.linux.maojaro = pacman

M.status = PackageStatus
M.bakup_option = DownloadOption

M.download_option = DownloadOption
M.git_option = GitOption

return M
