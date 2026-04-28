local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s("gid", fmt("document.getElementById('{}')", { i(1) })),
}
