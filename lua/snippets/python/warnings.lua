local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "war",
    name = "Warnings Section",
    desc = "Inserts a Warnings section for caveats (common extension).",
  }, {
    t({ "", "Warnings:", "    " }),
    i(1, "Warning details..."),
  }),
}
