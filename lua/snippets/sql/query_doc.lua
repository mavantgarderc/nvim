local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "qdoc",
    name = "SQL Query Doc Comment",
    desc = "Multi-line comment block for documenting a SQL query.",
  }, {
    t({ "/**", " * Query: " }),
    i(1, "Query Purpose"),
    t({ "", " *", " * Description: " }),
    i(2, "Brief description of what the query does."),
    t({ "", " *", " * Parameters: " }),
    i(3, "None or bind variables."),
    t({ "", " *", " * Returns: " }),
    i(4, "Description of result set."),
    t({ "", " *", " * Example:", " *   " }),
    i(5, "SELECT * FROM table WHERE condition;"),
    t({ "", " */" }),
  }),
}
