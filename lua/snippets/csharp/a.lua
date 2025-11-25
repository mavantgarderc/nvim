local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "a",
    name = "Hyperlink Inline Tag",
    desc = "Creates a hyperlink within documentation comments.",
  }, {
    t('<a href="'),
    i(1, "url"),
    t('">'),
    i(2, "text"),
    t("</a>"),
  }),
}
