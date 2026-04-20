local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"ctxp",
		fmt(
			[[
function {Name}Provider({children}) {{
  const [state, setState] = React.useState({init});
  const value = {{ state, setState }};

  return (
    <{Name}Context.Provider value={{value}}>
      {{children}}
    </{Name}Context.Provider>
  );
}}
  ]],
			{
				Name = ls.insert_node(1, "App"),
				children = ls.insert_node(2, "children"),
				init = ls.insert_node(3, "null"),
			}
		)
	),
}
