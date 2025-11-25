local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "par",
    name = "Nix Parameter Doc Line",
    desc = "Single comment line for documenting a parameter in functions or options.",
  }, {
    t("# - "),
    i(1, "param_name"),
    t(": "),
    i(2, "Description of parameter."),
  }),
}
