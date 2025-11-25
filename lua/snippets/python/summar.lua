local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "sum",
    name = "Summary Section",
    desc = "Inserts a one-line summary followed by a detailed description.",
  }, {
    i(1, "One-line summary."),
    t({ "", "" }),
    i(2, "Longer detailed description..."),
  }),
}
