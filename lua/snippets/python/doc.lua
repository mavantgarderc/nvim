local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "doc",
    name = "Full Function Docstring",
    desc = "Complete Google-style docstring for functions or methods, including summary, args, returns, and raises.",
  }, {
    t({ '"""', "" }),
    i(1, "One-line summary."),
    t({ "", "", "Args:", "    " }),
    i(2, "param1"),
    t(": "),
    i(3, "Description of param1."),
    t({ "", "", "Returns:", "    " }),
    i(4, "Description of return value."),
    t({ "", "", "Raises:", "    " }),
    i(5, "ExceptionType"),
    t(": "),
    i(6, "Description of when it's raised."),
    t({ "", '"""' }),
  }),
}
