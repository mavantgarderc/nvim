local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "br",
    name = "Line Break Inline Tag",
    desc = "Inserts a line break within documentation comments for single-spaced formatting.",
  }, {
    t("<br/>"),
  }),
}
