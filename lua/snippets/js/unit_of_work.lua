local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"uow",
		fmt(
			[[
class UnitOfWork {{
  constructor(client) {{
    this.client = client;
  }}

  async execute(work) {{
    const session = this.client.startSession();
    session.startTransaction();
    try {{
      const result = await work(session);
      await session.commitTransaction();
      return result;
    }} catch (err) {{
      await session.abortTransaction();
      throw err;
    }} finally {{
      await session.endSession();
    }}
  }}
}}

module.exports = UnitOfWork;
  ]],
			{}
		)
	),
}
