local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "pdoc",
    name = "SQL Stored Procedure Doc Comment",
    desc = "Multi-line comment block for documenting a stored procedure.",
  }, {
    t({ "/**", " * " }),
    i(1, "Procedure Name"),
    t({ "", " *", " * Description: " }),
    i(2, "Brief description of the procedure."),
    t({ "", " *", " * Parameters:", " *   @param1 " }),
    i(3, "datatype"),
    t(" - "),
    i(4, "Description of param1."),
    t({ "", " *", " * Returns: " }),
    i(5, "Description of return value."),
    t({ "", " *", " * Example:", " *   CALL ProcedureName(value1);", " */" }),
  }),
}
