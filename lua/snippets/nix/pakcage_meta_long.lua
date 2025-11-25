local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "plong",
    name = "Package Meta Long Description",
    desc = "Multi-line longDescription attribute in package meta, using heredoc string as in Nixpkgs manual.",
  }, {
    t("longDescription = ''"),
    t({ "", "  " }),
    i(1, "Detailed description of the package."),
    t({ "", "  Additional details here.", "'';" }),
  }),
}
