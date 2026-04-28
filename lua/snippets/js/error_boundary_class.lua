local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"errb",
		fmt(
			[[
class {Name}Boundary extends React.Component {{
  constructor(props) {{
    super(props);
    this.state = {{ hasError: false }};
  }}

  static getDerivedStateFromError(error) {{
    return {{ hasError: true }};
  }}

  componentDidCatch(error, info) {{
    console.error(error, info);
  }}

  render() {{
    if (this.state.hasError) {{
      return <{Fallback} />;
    }}
    return this.props.children;
  }}
}}
  ]],
			{
				Name = ls.insert_node(1, "Error"),
				Fallback = ls.insert_node(2, "ErrorFallback"),
			}
		)
	),
}
