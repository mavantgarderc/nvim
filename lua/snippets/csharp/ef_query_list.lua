local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"eflist",
		fmt(
			[[
var items = await _context.{Set}.ToListAsync();
  ]],
			{
				Set = ls.insert_node(1, "Users"),
			}
		)
	),
}
