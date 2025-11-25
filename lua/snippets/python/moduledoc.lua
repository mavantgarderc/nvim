local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "mdoc",
    name = "Module Docstring",
    desc = "Google-style docstring for modules, including summary and usage example.",
  }, {
    t({ '"""', "" }),
    i(1, "One-line summary of the module."),
    t({ "", "", "Overall description of the module.", "", "Typical usage example:", "", "    foo = " }),
    i(2, "ClassFoo()"),
    t({ "", "    bar = foo." }),
    i(3, "function_bar()"),
    t({ "", '"""' }),
  }),
}
