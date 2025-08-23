-- File: Raphael/keymaps.lua

local o = vim.o
local split = vim.split
local ui = vim.ui
local cmd = vim.cmd
local map = vim.keymap.set
local tbl_deep_extend = vim.tbl_deep_extend
local log = vim.log
local notify = vim.notify
local g = vim.g
local unmap = vim.keymap.del
local api = vim.api
local fn = vim.fn
local defer_fn = vim.defer_fn
local bo = vim.bo

local picker = require("Raphael.scripts.picker")
local cycler = require("Raphael.scripts.cycler")
local preview = require("Raphael.scripts.preview")

local M = {}

M.config = {
  leader = "<leader>t",
  mappings = {
    picker = "p",
    picker_toml = "P",
    picker_builtin = "b",
    next = "n",
    previous = "N",
    random = "r",
    next_toml = "<C-n>",
    prev_toml = "<C-p>",
    next_dark = "<A-n>",
    prev_dark = "<A-p>",
    auto_cycle = "a",
    stop_cycle = "s",
    cycle_info = "i",
    preview = "v",
    quick_preview = "q",
    compare = "c",
    slideshow = "S",
    info = "I",
    status = "?",
    reload = "R",
    validate = "V",
  },
  global = {
    cycle_forward = "<F9>",
    cycle_backward = "<F8>",
    quick_picker = "<F10>",
    emergency_reset = "<F7>",
  }
}

function M.setup_keymaps(user_config)
  if user_config then
    M.config = tbl_deep_extend("force", M.config, user_config)
  end

  local leader = M.config.leader
  local mappings = M.config.mappings
  local global = M.config.global

  -- Picker mappings
  map("n", leader .. mappings.picker, function()
    picker.open_picker()
  end, { desc = "Open Raphael theme picker" })

  map("n", leader .. mappings.picker_toml, function()
    picker.open_picker("toml")
  end, { desc = "Open TOML colorscheme picker" })

  map("n", leader .. mappings.picker_builtin, function()
    picker.open_picker("builtin")
  end, { desc = "Open built-in colorscheme picker" })

  -- Cycling mappings
  map("n", leader .. mappings.next, function() cycler.cycle_next("all") end, { desc = "Next colorscheme" })
  map("n", leader .. mappings.previous, function() cycler.cycle_previous("all") end, { desc = "Previous colorscheme" })
  map("n", leader .. mappings.random, function() cycler.cycle_random("all") end, { desc = "Random colorscheme" })
  map("n", leader .. mappings.next_toml, function() cycler.cycle_next("toml") end, { desc = "Next TOML colorscheme" })
  map("n", leader .. mappings.prev_toml, function() cycler.cycle_previous("toml") end, { desc = "Previous TOML colorscheme" })
  map("n", leader .. mappings.next_dark, function() cycler.cycle_next("dark") end, { desc = "Next dark colorscheme" })
  map("n", leader .. mappings.prev_dark, function() cycler.cycle_previous("dark") end, { desc = "Previous dark colorscheme" })

  -- Auto-cycle
  map("n", leader .. mappings.auto_cycle, function() cycler.toggle_auto_cycle("all", 5000) end, { desc = "Toggle auto-cycle" })
  map("n", leader .. mappings.stop_cycle, function() cycler.stop_auto_cycle() end, { desc = "Stop auto-cycle" })
  map("n", leader .. mappings.cycle_info, function() cycler.show_cycle_info() end, { desc = "Show cycle information" })

  -- Preview mappings
  map("n", leader .. mappings.preview, function()
    local current = require("Raphael.scripts.loader").get_current_colorscheme()
    preview.preview_colorscheme(current.name, current.type, 5000)
  end, { desc = "Preview current colorscheme in window" })

  map("n", leader .. mappings.quick_preview, function()
    ui.input({ prompt = "Colorscheme to preview: " }, function(input)
      if input and input ~= "" then
        local colors_config = require("Raphael.colors")
        local scheme_type = colors_config.is_toml_colorscheme(input) and "toml" or "builtin"
        preview.quick_preview(input, scheme_type, 2000)
      end
    end)
  end, { desc = "Quick preview colorscheme" })

  map("n", leader .. mappings.compare, function()
    ui.input({ prompt = "Colorschemes to compare (space-separated): " }, function(input)
      if input and input ~= "" then
        local names = split(input, "%s+")
        if #names >= 2 then
          local colorschemes = {}
          local all_colorschemes = require("Raphael.colors").get_all_colorschemes()
          for _, name in ipairs(names) do
            for _, cs in ipairs(all_colorschemes) do
              if cs.name == name then table.insert(colorschemes, cs) break end
            end
          end
          preview.compare_colorschemes(colorschemes)
        else
          notify("Need at least 2 colorschemes to compare", log.levels.WARN)
        end
      end
    end)
  end, { desc = "Compare multiple colorschemes" })

  map("n", leader .. mappings.slideshow, function()
    local colorschemes = require("Raphael.colors").get_all_colorschemes()
    local stop_fn = preview.slideshow_preview(colorschemes, 3000, true)
    g.raphael_slideshow_stop = stop_fn
  end, { desc = "Start colorscheme slideshow" })

  -- Info & management
  map("n", leader .. mappings.info, function() cmd("RaphaelInfo") end, { desc = "Show current colorscheme info" })
  map("n", leader .. mappings.status, function() cmd("RaphaelStatus") end, { desc = "Show system status" })
  map("n", leader .. mappings.reload, function() cmd("RaphaelReload") end, { desc = "Reload TOML colorschemes" })
  map("n", leader .. mappings.validate, function() cmd("RaphaelValidate") end, { desc = "Validate TOML colorschemes" })

  -- Global mappings
  if global.cycle_forward then map("n", global.cycle_forward, function() cycler.cycle_next("all") end, { desc = "Next colorscheme (global)" }) end
  if global.cycle_backward then map("n", global.cycle_backward, function() cycler.cycle_previous("all") end, { desc = "Previous colorscheme (global)" }) end
  if global.quick_picker then map("n", global.quick_picker, function() picker.open_picker() end, { desc = "Quick theme picker (global)" }) end
  if global.emergency_reset then
    map("n", global.emergency_reset, function()
      local default_config = require("Raphael.colors").config.default_colorscheme
      if default_config then
        require("Raphael.scripts.loader").apply_colorscheme(default_config.name, default_config.type or "toml")
        notify("Reset to default colorscheme", log.levels.INFO)
      else
        cmd("colorscheme default")
        notify("Reset to Vim default colorscheme", log.levels.INFO)
      end
    end, { desc = "Emergency reset to default theme" })
  end
end

-- Expose keymap config
function M.get_keymap_config() return M.config end
function M.update_keymap_config(new_config) M.config = tbl_deep_extend("force", M.config, new_config) end
function M.remove_keymaps()
  local leader, mappings, global = M.config.leader, M.config.mappings, M.config.global
  for _, m in pairs(mappings) do pcall(unmap, "n", leader .. m) end
  for _, m in pairs(global) do if m then pcall(unmap, "n", m) end end
end

-- Show keymaps in a window
function M.show_keymaps()
  local leader, mappings, global = M.config.leader, M.config.mappings, M.config.global
  local lines = { "Raphael Theme System - Key Mappings:", "" }
  table.insert(lines, "Picker Commands (prefix: " .. leader .. "):")
  for _, k in ipairs({ "picker","picker_toml","picker_builtin" }) do table.insert(lines, "  " .. leader .. mappings[k] .. " - Open picker") end
  table.insert(lines, "")
  table.insert(lines, "Cycling Commands:")
  for _, k in ipairs({ "next","previous","random","next_toml","prev_toml","next_dark","prev_dark" }) do
    table.insert(lines, "  " .. leader .. mappings[k] .. " - " .. k)
  end
  local buf = api.nvim_create_buf(false,true)
  api.nvim_buf_set_lines(buf,0,-1,false,lines)
  local win = api.nvim_open_win(buf,true,{
    relative="editor",width=60,height=math.min(#lines+2,o.lines-4),
    row=math.floor((o.lines-math.min(#lines+2,o.lines-4))/2),
    col=math.floor((o.columns-60)/2),
    style="minimal",border="rounded",title=" Key Mappings ",title_pos="center"
  })
  api.nvim_buf_set_option(buf,"bufhidden","wipe")
  map("n","q",function() api.nvim_win_close(win,true) end,{buffer=buf})
  map("n","<Esc>",function() api.nvim_win_close(win,true) end,{buffer=buf})
end

return M
