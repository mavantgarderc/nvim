local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s("typ", fmt("type {} = {};", { i(1, "Name"), i(2, "string") })),
}
