local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"esnap",
		fmt(
			[[
async function snapshot(store, id, reducer, versionInterval = {interval}) {{
  const events = await store.getEvents(id);
  if (events.length < versionInterval) return;

  const state = events.reduce(reducer, {{}});
  await store.saveSnapshot(id, state, events.length);
}}

module.exports = snapshot;
  ]],
			{
				interval = ls.insert_node(1, "100"),
			}
		)
	),
}
