local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "perm",
    name = "Permission Doc Comment",
    desc = "Adds a <permission> XML documentation comment for permissions.",
  }, {
    t('/// <permission cref="'),
    i(1, "member"),
    t('">'),
    i(2, "description"),
    t("</permission>"),
  }),
}
