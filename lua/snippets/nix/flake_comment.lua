local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "fcom",
    name = "Nix Flake Comment",
    desc = "Top-level comment in flake.nix, describing the flake's purpose and structure.",
  }, {
    t({ "# Flake: " }),
    i(1, "FlakeName"),
    t({ "", "#", "# Description: " }),
    i(2, "Overall purpose of the flake."),
    t({ "", "#", "# Inputs:", "# - input1: Description." }),
    t({ "", "#", "# Outputs:", "# - packages: Description." }),
  }),
}
