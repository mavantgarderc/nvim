local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"udv",
		fmt(
			[[
const {deferred} = React.useDeferredValue({value});
  ]],
			{
				deferred = ls.insert_node(1, "deferredValue"),
				value = ls.insert_node(2, "value"),
			}
		)
	),
}
