local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"gctune",
		fmt(
			[[
GCSettings.LatencyMode = {mode};
Console.WriteLine($"Server GC: {{GCSettings.IsServerGC}}");
  ]],
			{
				mode = ls.insert_node(1, "GCLatencyMode.SustainedLowLatency"),
			}
		)
	),
}
