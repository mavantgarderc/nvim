local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "fdoc",
    name = "SQL Function Doc Comment",
    desc = "Multi-line comment block for documenting a user-defined function.",
  }, {
    t({ "/**", " * " }),
    i(1, "Function Name"),
    t({ "", " *", " * Description: " }),
    i(2, "Brief description of the function."),
    t({ "", " *", " * Parameters:", " *   @param1 " }),
    i(3, "datatype"),
    t(" - "),
    i(4, "Description of param1."),
    t({ "", " *", " * Returns: " }),
    i(5, "datatype"),
    t(" - "),
    i(6, "Description of return value."),
    t({ "", " *", " * Example:", " *   SELECT FunctionName(value1);", " */" }),
  }),
}
