local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s("ac", fmt("{}.appendChild({});", { i(1, "parent"), i(2, "child") })),
}
