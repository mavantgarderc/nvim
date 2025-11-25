local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "desc",
    name = "SQL Description Doc Section",
    desc = "Section for a detailed description.",
  }, {
    t({ " *", " * Description: " }),
    i(1, "Detailed description..."),
  }),
}
