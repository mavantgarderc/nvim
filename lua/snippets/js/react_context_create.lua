local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local i = ls.insert_node

return {
	s(
		"ctx",
		fmt(
			[[
const {}Context = React.createContext(null);

export function {}Provider({{ children }}) {{
  const [state, setState] = React.useState({});
  return (
    <{}Context.Provider value={{{{ state, setState }}}}>
      {{children}}
    </{}Context.Provider>
  );
}}
]],
			{
				i(1, "App"),
				rep(1),
				i(2, "{}"),
				rep(1),
				rep(1),
			}
		)
	),
}
