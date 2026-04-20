local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"wrk",
		fmt(
			[[
const {{ Worker }} = require("worker_threads");

function runWorker(path, workerData) {{
  return new Promise((resolve, reject) => {{
    const worker = new Worker(path, {{ workerData }});
    worker.on("message", resolve);
    worker.on("error", reject);
    worker.on("exit", (code) => {{
      if (code !== 0) reject(new Error(`Worker stopped: ${code}`));
    }});
  }});
}}

module.exports = runWorker;
  ]],
			{}
		)
	),
}
