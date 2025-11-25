local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "npex",
    name = "NumPy Examples Section",
    desc = "Inserts an Examples section in NumPy style with doctest format.",
  }, {
    t({ "", "Examples", "--------" }),
    t({ "", "" }),
    t(">>> "),
    i(1, "import numpy as np"),
    t({ "", ">>> " }),
    i(2, "result = function_call()"),
    t({ "", "" }),
    i(3, "Expected output description."),
  }),
}
