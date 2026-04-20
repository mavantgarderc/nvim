local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"urc",
		fmt(
			[[
const initialState = {{}};

function reducer(state, action) {{
  switch (action.type) {{
    case '{}':
      return {{
        ...state,
        {}
      }};
    default:
      return state;
  }}
}}

const [state, dispatch] = React.useReducer(reducer, initialState);
]],
			{ i(1, "SET"), i(2) }
		)
	),
}
