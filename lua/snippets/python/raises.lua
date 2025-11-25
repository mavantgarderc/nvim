local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "rai",
    name = "Raises Section",
    desc = "Inserts the Raises section with an example exception.",
  }, {
    t({ "", "Raises:", "    " }),
    i(1, "ExceptionType"),
    t(": "),
    i(2, "Description of when it's raised."),
  }),
}
