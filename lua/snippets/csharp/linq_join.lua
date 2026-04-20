local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"linqjoin",
		fmt(
			[[
var results =
    {left}.Join(
        {right},
        l => {leftKey},
        r => {rightKey},
        (l, r) => new {{
            Left = l,
            Right = r
        }}
    ).ToList();
  ]],
			{
				left = ls.insert_node(1, "users"),
				right = ls.insert_node(2, "orders"),
				leftKey = ls.insert_node(3, "l.Id"),
				rightKey = ls.insert_node(4, "r.UserId"),
			}
		)
	),
}
