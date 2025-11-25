local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "ref",
    name = "References Section",
    desc = "Inserts a References section for citations (common in scientific/ML code).",
  }, {
    t({ "", "References:", "    " }),
    i(1, "Citation or link..."),
  }),
}
