local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"rfcts",
		fmt(
			[[
import React from 'react';

interface {}Props {{
  {}: {};
}}

const {}: React.FC<{}Props> = ({ {} }) => {{
  return (
    <div>{}</div>
  );
}};

export default {};
]],
			{
				i(1, "Component"),
				i(2, "value"),
				i(3, "string"),
				rep(1),
				rep(1),
				rep(2),
				"content",
				rep(1),
			}
		)
	),
}
