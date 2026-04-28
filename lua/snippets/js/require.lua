local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s("req", fmt("const {} = require('{}');", { i(1, "module"), i(2, "module-name") })),
}
