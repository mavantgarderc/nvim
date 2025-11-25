local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "fmcom",
    name = "Nix Multi-line Function Comment",
    desc = "Multi-line block comment for documenting functions, using /* */ as per Nix syntax.",
  }, {
    t({ "/*", "  " }),
    i(1, "Function Name"),
    t({ "", "", "  Description: " }),
    i(2, "Brief description of the function."),
    t({ "", "", "  Parameters:", "    param1: Description of param1." }),
    t({ "", "", "  Returns: Description of return value.", "*/" }),
  }),
}
