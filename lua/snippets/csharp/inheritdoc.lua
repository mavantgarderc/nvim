local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "inh",
    name = "Inheritdoc Doc Comment",
    desc = "Inherits XML documentation from a base class, interface, or specific member.",
  }, {
    t('/// <inheritdoc cref="'),
    i(1, "member"),
    t('" />'),
  }),
}
