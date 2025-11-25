local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "item",
    name = "Item Inline Tag",
    desc = "Adds an <item> for list entries within <list> doc comments.",
  }, {
    t("/// <item>"),
    t({ "", "///   <term>" }),
    i(1, "term"),
    t("</term>"),
    t({ "", "///   <description>" }),
    i(2, "description"),
    t("</description>"),
    t({ "", "/// </item>" }),
  }),
}
