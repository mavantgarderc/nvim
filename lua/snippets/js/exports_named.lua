local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s("exn", fmt("exports.{} = {};", { i(1, "name"), i(2, "value") })),
}
