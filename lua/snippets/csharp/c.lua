local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "c",
    name = "C Inline Tag",
    desc = "Adds a <c> inline tag for code literals within doc comments.",
  }, {
    t("<c>"),
    i(1, "text"),
    t("</c>"),
  }),
}
