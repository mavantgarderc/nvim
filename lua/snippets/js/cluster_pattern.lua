local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"cluster",
		fmt(
			[[
const cluster = require("cluster");
const os = require("os");

if (cluster.isPrimary) {{
  const cpuCount = os.cpus().length;
  for (let i = 0; i < cpuCount; i++) cluster.fork();

  cluster.on("exit", (worker) => {{
    console.log(`Worker ${worker.process.pid} died. Restarting...`);
    cluster.fork();
  }});
}} else {{
  require("./server"); // worker logic
}}
  ]],
			{}
		)
	),
}
