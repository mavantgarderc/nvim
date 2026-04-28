local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"ufetch",
		fmt(
			[[
function useFetch(url) {{
  const [data, setData] = React.useState(null);
  const [loading, setLoading] = React.useState(true);
  const [error, setError] = React.useState(null);

  React.useEffect(() => {{
    let active = true;
    fetch(url)
      .then((r) => r.json())
      .then((d) => active && setData(d))
      .catch(setError)
      .finally(() => active && setLoading(false));
    return () => (active = false);
  }}, [url]);

  return {{ data, loading, error }};
}}
]],
			{}
		)
	),
}
