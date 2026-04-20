local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s("clr", fmt("{}.classList.remove('{}');", { i(1, "el"), i(2, "class") })),
}
