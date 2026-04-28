local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"gstop",
		fmt(
			[[
function graceful(server, cleanup = async () => {{}}) {{
  const signals = ["SIGINT", "SIGTERM"];

  signals.forEach(sig => {{
    process.on(sig, async () => {{
      console.log("Shutting down...");
      server.close(async () => {{
        await cleanup();
        process.exit(0);
      }});
    }});
  }});
}}

module.exports = graceful;
  ]],
			{}
		)
	),
}
