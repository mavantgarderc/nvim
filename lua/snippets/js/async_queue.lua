local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"aqueue",
		fmt(
			[[
function createQueue(concurrency, worker) {{
  const queue = [];
  let active = 0;

  async function run() {{
    if (active >= concurrency || queue.length === 0) return;
    active++;
    const task = queue.shift();
    try {{ await worker(task); }} finally {{
      active--;
      run();
    }}
  }}

  return {{
    push: (task) => {{
      queue.push(task);
      run();
    }},
  }};
}}

module.exports = createQueue;
  ]],
			{}
		)
	),
}
