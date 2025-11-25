local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "mcom",
    name = "Nix Module Comment",
    desc = "Comment block at the top of a NixOS module file, describing the module's purpose.",
  }, {
    t({ "# Module: " }),
    i(1, "ModuleName"),
    t({ "", "#", "# Description: " }),
    i(2, "Brief description of the module."),
    t({ "", "#", "# Options:", "# - option1: Description." }),
  }),
}
