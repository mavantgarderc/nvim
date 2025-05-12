-- ============================================================================
-- Custom Commands — core/commands.lua
-- ============================================================================
-- Declarative :commands to extend user workflows.
-- ============================================================================
local api = vim.api

-- ============================================================================
-- :ReloadConfig — Hot reload your entire config in-session
api.nvim_create_user_command("ReloadConfig", function()
  for name, _ in pairs(package.loaded) do
    if name:match("^core") or name:match("^plugins") or name:match("^ui") then
      package.loaded[name] = nil
    end
  end
  dofile(vim.fn.stdpath("config") .. "/init.lua")
  vim.notify("✅ Configuration Reloaded", vim.log.levels.INFO)
end, { desc = "Reload Neovim configuration" })

-- ============================================================================
-- :TrimWhitespace — Clean up extra space on demand
api.nvim_create_user_command("TrimWhitespace", function()
  local view = vim.fn.winsaveview()
  vim.cmd([[%s/\s\+$//e]])
  vim.fn.winrestview(view)
end, { desc = "Remove trailing whitespace in buffer" })

-- ============================================================================
-- :SpellToggle — Quick toggle for spell checking
api.nvim_create_user_command("SpellToggle", function()
  vim.opt.spell = not vim.opt.spell:get()
  vim.notify("🔤 Spellcheck: " .. (vim.opt.spell:get() and "ON" or "OFF"))
end, { desc = "Toggle spell checking" })

-- ============================================================================
-- :InspectSyntax — Debug Treesitter syntax groups at cursor
api.nvim_create_user_command("InspectSyntax", function()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local node = ts_utils.get_node_at_cursor()
  if node then
    print("🧬 Syntax Node: " .. node:type())
  else
    print("⚠️ No syntax node found.")
  end
end, { desc = "Print Treesitter node type at cursor" })

-- ============================================================================
-- :ReloadColors — Refresh current colorscheme
api.nvim_create_user_command("ReloadColors", function()
  local colorscheme = vim.g.colors_name
  vim.cmd("colorscheme " .. colorscheme)
  vim.notify("🎨 Colorscheme reloaded: " .. colorscheme)
end, { desc = "Reapply current colorscheme" })

-- ============================================================================
-- :ToggleRelativeNumbers — Optional convenience
api.nvim_create_user_command("ToggleRelNum", function()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, { desc = "Toggle relative line numbers" })

-- ============================================================================
-- 🧩 Commands initialized
-- ============================================================================