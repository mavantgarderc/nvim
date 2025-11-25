local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "ret",
    name = "Returns Doc Comment",
    desc = "Adds a <returns> XML documentation comment for method return values.",
  }, {
    t("/// <returns>"),
    t({ "", "/// " }),
    i(1, "description"),
    t({ "", "/// </returns>" }),
  }),
}
