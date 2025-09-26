local themes = require("Raphael.themes")

local M = {}

function M.setup(core)
  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
      if not core.state.enabled then return end
      local ft = vim.bo.filetype
      local theme = themes.filetype_themes[ft]
      if theme and themes.is_available(theme) then
        core.apply(theme)
      else
        core.apply("kanagawa-paper-ink")
      end
    end,
  })
end

return M
