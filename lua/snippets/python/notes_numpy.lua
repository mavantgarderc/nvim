local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "npnot",
    name = "NumPy Notes Section",
    desc = "Inserts a Notes section in NumPy style.",
  }, {
    t({ "", "Notes", "-----" }),
    t({ "", "" }),
    i(1, "Additional notes..."),
  }),
}
