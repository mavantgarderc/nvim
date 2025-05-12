-- ============================================================================
-- Neovim Entry Point: init.lua
-- ============================================================================
-- Bootstrap script for modular Lua-based Neovim setup using lazy.nvim
-- ----------------------------------------------------------------------------
-- ▸ Loads core configurations
-- ▸ Initializes plugin manager (lazy.nvim)
-- ▸ Lazy-loads plugin declarations and UI configurations
-- ============================================================================

-- 1. --------------------------------------------------------------------------
-- ENVIRONMENT SETUP ----------------------------------------------------------
-- Extend Lua runtime path for Lua modules inside `lua/`
-- ----------------------------------------------------------------------------
local fn = vim.fn
local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Auto-install lazy.nvim if missing
if not vim.loop.fs_stat(lazypath) then
  print("▶ Installing lazy.nvim plugin manager...")
  fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- Latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- 2. --------------------------------------------------------------------------
-- LOAD CORE MODULES -----------------------------------------------------------
-- Load editor behavior, keybindings, and other essential DNA
-- ----------------------------------------------------------------------------
require("core.options")    -- Editor settings (number, scrolloff, etc.)
require("core.keymaps")    -- Leader bindings, mode mappings
require("core.autocmds")   -- Auto commands & filetype triggers
require("core.commands")   -- Custom :Commands for workflows

-- 3. --------------------------------------------------------------------------
-- PLUGIN INITIALIZATION -------------------------------------------------------
-- This uses Lazy.nvim for performance-aware lazy-loading of all plugins
-- Plugins are declared modularly in `lua/plugins/init.lua`
-- ----------------------------------------------------------------------------
require("plugins.init")    -- Plugin declarations & lazy loading config

-- 4. --------------------------------------------------------------------------
-- UI + STATUSLINE + THEMES ---------------------------------------------------
-- Separately scoped for presentation logic
-- ----------------------------------------------------------------------------
require("ui.statusline")
require("ui.highlights")
require("ui.themes")

-- 5. --------------------------------------------------------------------------
-- OPTIONAL: Telemetry & Session Resumption (User-dependent)
-- ----------------------------------------------------------------------------
pcall(require, "core.telemetry")   -- Load non-blocking performance audit
pcall(require, "core.sessionss")   -- Auto session restore/save

-- ============================================================================
-- 🔹 System initialized. Time to craft something brilliant.
-- ============================================================================
