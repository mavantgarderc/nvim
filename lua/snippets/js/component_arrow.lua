local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local rep = require("luasnip.extras.fmt").rep

return {
	s(
		"rca",
		fmt(
			[[
const {} = ({}) => {{
  return (
    <div>
      {}
    </div>
  );
}};
export default {};
]],
			{
				i(1, "Component"),
				i(2),
				i(3, "content"),
				rep(1),
			}
		)
	),
}
