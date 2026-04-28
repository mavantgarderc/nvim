local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"iasync",
		fmt(
			[[
public async IAsyncEnumerable<{Type}> {Name}Async()
{{
  {body}
}}
  ]],
			{
				Type = ls.insert_node(1, "int"),
				Name = ls.insert_node(2, "StreamValues"),
				body = ls.insert_node(3, "yield return await Task.FromResult(1);"),
			}
		)
	),
}
