local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"asw",
		fmt(
			[[
const asyncWrap = (fn) => (req, res, next) => {{
  Promise.resolve(fn(req, res, next)).catch(next);
}};

module.exports = asyncWrap;
  ]],
			{}
		)
	),
}
