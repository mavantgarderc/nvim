local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"portal",
		fmt(
			[[
return ReactDOM.createPortal(
  {},
  document.getElementById('{}')
);
]],
			{
				i(1, "<div/>"),
				i(2, "root"),
			}
		)
	),
}
