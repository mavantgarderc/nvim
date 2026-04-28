local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"controller",
		fmt(
			[[
[ApiController]
[Route("api/[controller]")]
public class {Name}Controller : ControllerBase
{{
    {body}
}}
  ]],
			{
				Name = ls.insert_node(1, "Users"),
				body = ls.insert_node(2, "// actions"),
			}
		)
	),
}
