local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s("mex", fmt("module.exports = {};", { i(1, "{}") })),
}
