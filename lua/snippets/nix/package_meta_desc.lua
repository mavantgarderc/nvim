local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "pdesc",
    name = "Package Meta Description",
    desc = "Short description attribute in package meta, following Nixpkgs conventions.",
  }, {
    t('description = "'),
    i(1, "A short description of the package."),
    t('";'),
  }),
}
