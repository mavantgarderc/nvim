local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "ret",
    name = "Returns Section",
    desc = "Inserts the Returns section with a description.",
  }, {
    t({ "", "Returns:", "    " }),
    i(1, "Description of return value."),
  }),
}
