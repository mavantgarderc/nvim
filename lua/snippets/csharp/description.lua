local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "desc",
    name = "Description Inline Tag",
    desc = "Adds a <description> for list items within <list> or <listheader>.",
  }, {
    t("<description>"),
    i(1, "description"),
    t("</description>"),
  }),
}
