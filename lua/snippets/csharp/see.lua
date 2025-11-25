local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "see",
    name = "See Inline Tag",
    desc = "Adds a <see> inline tag for cross-references.",
  }, {
    t('<see cref="'),
    i(1, "member"),
    t('" />'),
  }),
}
