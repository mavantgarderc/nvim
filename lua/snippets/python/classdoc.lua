local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "cdoc",
    name = "Class Docstring",
    desc = "Google-style docstring for classes, including summary and attributes.",
  }, {
    t({ '"""', "" }),
    i(1, "Summary of the class."),
    t({ "", "", "Attributes:", "    " }),
    i(2, "attr1"),
    t(": "),
    i(3, "Description of attr1."),
    t({ "", '"""' }),
  }),
}
