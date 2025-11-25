local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "npmeth",
    name = "NumPy Methods Section",
    desc = "Inserts a Methods section in NumPy style for classes.",
  }, {
    t({ "", "Methods", "-------" }),
    t({ "", "" }),
    i(1, "method_name(param)"),
    t({ "", "    Short description of method." }),
  }),
}
