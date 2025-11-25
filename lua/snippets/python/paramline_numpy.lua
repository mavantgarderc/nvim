local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "nppl",
    name = "NumPy Parameter Line",
    desc = "Inserts a single parameter line in NumPy style.",
  }, {
    t({ "", "" }),
    i(1, "param : type"),
    t({ "", "    Description of param." }),
  }),
}
