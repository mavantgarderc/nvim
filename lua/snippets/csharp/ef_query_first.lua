local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"effirst",
		fmt(
			[[
var result = await _context.{Set}.FirstOrDefaultAsync(x => x.Id == {id});
  ]],
			{
				Set = ls.insert_node(1, "Users"),
				id = ls.insert_node(2, "id"),
			}
		)
	),
}
