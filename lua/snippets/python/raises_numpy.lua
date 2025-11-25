local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "nprai",
    name = "NumPy Raises Section",
    desc = "Inserts a Raises section in NumPy style.",
  }, {
    t({ "", "Raises", "------" }),
    t({ "", "" }),
    i(1, "ExceptionType"),
    t({ "", "    Description of when it's raised." }),
  }),
}
