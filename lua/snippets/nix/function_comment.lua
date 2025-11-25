local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "fcom",
    name = "Nix Function Comment",
    desc = "Single-line or multi-line comment above a function definition, common in Nixpkgs for documentation.",
  }, {
    t("# "),
    i(1, "Function Name: Brief description."),
    t({ "", "#", "# Parameters:", "# - param1: Description of param1." }),
    t({ "", "#", "# Returns: Description of return value." }),
  }),
}
