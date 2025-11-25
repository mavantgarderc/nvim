local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "nppar",
    name = "NumPy Parameters Section",
    desc = "Inserts a Parameters section in NumPy style.",
  }, {
    t({ "", "Parameters", "----------" }),
    t({ "", "" }),
    i(1, "param1 : type"),
    t({ "", "    Description of param1." }),
  }),
}
