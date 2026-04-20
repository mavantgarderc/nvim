local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"rerr",
		fmt(
			[[
class {}Boundary extends React.Component {{
  constructor(props) {{
    super(props);
    this.state = {{ hasError: false }};
  }}

  static getDerivedStateFromError(_) {{
    return {{ hasError: true }};
  }}

  componentDidCatch(err) {{
    console.error(err);
  }}

  render() {{
    if (this.state.hasError) return {};
    return this.props.children;
  }}
}}
]],
			{
				i(1, "Error"),
				i(2, "<div>Something went wrong</div>"),
			}
		)
	),
}
