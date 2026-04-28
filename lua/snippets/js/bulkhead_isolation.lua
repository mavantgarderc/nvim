local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"bulk",
		fmt(
			[[
function bulkhead(limit) {{
  let active = 0;
  const queue = [];

  async function run(task, resolve, reject) {{
    active++;
    try {{ resolve(await task()); }}
    catch (e) {{ reject(e); }}
    finally {{
      active--;
      if (queue.length > 0) {{
        const next = queue.shift();
        run(next.task, next.resolve, next.reject);
      }}
    }}
  }}

  return (task) => new Promise((resolve, reject) => {{
    if (active < limit) run(task, resolve, reject);
    else queue.push({{ task, resolve, reject }});
  }});
}}

module.exports = bulkhead;
  ]],
			{}
		)
	),
}
