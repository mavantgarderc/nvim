-- Raphael: main entry point

local Raphael = {}

Raphael.state = {
  current = "kanagawa-paper-ink",
  previous = nil,
  auto_apply = false,
  bookmarks = {},
}

Raphael.config = {
  leader = "<leader>t",
  mappings = { picker = "p", next = "n", previous = "N", random = "r" },
}

local path = vim.fn.expand("~") .. "/raphael.lua"

-- load saved state if it exists
local function load_state()
  if vim.fn.filereadable(path) == 1 then
    local ok, tbl = pcall(dofile, path)
    if ok and type(tbl) == "table" then
      for k,v in pairs(tbl) do
        Raphael.state[k] = v
      end
    end
  end
end

-- save state asynchronously
local function save_state()
  local f = io.open(path, "w")
  if not f then return end
  local content = "return " .. vim.inspect(Raphael.state)
  f:write(content)
  f:close()
end

-- safe requires
Raphael.colors = require("Raphael.colors")
Raphael.themes = require("Raphael.themes")
Raphael.themes.refresh()
Raphael.picker = require("Raphael.picker")

-- apply theme
function Raphael.apply(theme)
  if not theme or not Raphael.themes.is_available(theme) then
    vim.notify("Raphael: theme not available: " .. tostring(theme), vim.log.levels.WARN)
    return
  end
  Raphael.state.previous = Raphael.state.current
  Raphael.state.current = theme
  vim.cmd.colorscheme(theme)
  save_state()  -- persist immediately
end

-- toggle auto-theme
function Raphael.toggle_auto()
  Raphael.state.auto_apply = not Raphael.state.auto_apply
  vim.notify(Raphael.state.auto_apply and "Raphael auto-theme: ON" or "Raphael auto-theme: OFF")
  save_state()
end

-- open picker
function Raphael.open_picker()
  Raphael.picker.open(Raphael)
end

-- filetype auto-apply
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    if not Raphael.state.auto_apply then return end
    local ft = args.match
    local theme = Raphael.themes.filetype_themes[ft]
    if theme then Raphael.apply(theme) end
  end,
})

-- keymaps
vim.keymap.set("n", Raphael.config.leader .. Raphael.config.mappings.picker, Raphael.open_picker, { desc = "Open Raphael Theme Picker" })
vim.keymap.set("n", Raphael.config.leader .. "ta", Raphael.toggle_auto, { desc = "Toggle Raphael auto-theme" })

-- load saved theme on startup
load_state()
vim.schedule(function()
  if Raphael.themes.is_available(Raphael.state.current) then
    vim.cmd.colorscheme(Raphael.state.current)
  else
    vim.cmd.colorscheme("kanagawa-paper-ink")
  end
end)

return Raphael
