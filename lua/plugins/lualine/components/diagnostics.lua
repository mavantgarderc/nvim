local glyphs = require("plugins.lualine.utils.glyphs")

return {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn" },
  symbols = {
    error = glyphs.diagnostics.error,
    warn = glyphs.diagnostics.warn,
  },
  colored = false,
  update_in_insert = false,
  always_visible = true,
}
