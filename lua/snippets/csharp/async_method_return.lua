local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"asyncmr",
		fmt(
			[[
public async Task<{Return}> {Name}Async({params})
{{
  {body}
}}
  ]],
			{
				Return = ls.insert_node(1, "int"),
				Name = ls.insert_node(2, "Compute"),
				params = ls.insert_node(3, ""),
				body = ls.insert_node(4, "return await Task.FromResult(0);"),
			}
		)
	),
}
