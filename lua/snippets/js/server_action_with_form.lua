local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"sactform",
		fmt(
			[[
"use server";

export async function {action}(formData) {{
  {logic}
}}

export default function Page() {{
  return (
    <form action={{ {action} }}>
      {fields}
      <button type="submit">{button}</button>
    </form>
  );
}}
  ]],
			{
				action = ls.insert_node(1, "submitForm"),
				logic = ls.insert_node(2, "// handle form data"),
				fields = ls.insert_node(3, '<input name="name" />'),
				button = ls.insert_node(4, "Submit"),
			}
		)
	),
}
