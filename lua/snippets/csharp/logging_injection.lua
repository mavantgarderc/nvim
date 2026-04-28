local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"ilogger",
		fmt(
			[[
private readonly ILogger<{Type}> _logger;

public {Type}(ILogger<{Type}> logger)
{{
    _logger = logger;
}}
  ]],
			{
				Type = ls.insert_node(1, "MyService"),
			}
		)
	),
}
