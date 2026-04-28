local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"rbmq",
		fmt(
			[[
const amqp = require("amqplib");

async function initRabbit(queue) {{
  const conn = await amqp.connect("amqp://localhost");
  const ch = await conn.createChannel();
  await ch.assertQueue(queue);

  return {{
    publish: (msg) => ch.sendToQueue(queue, Buffer.from(msg)),
    consume: (cb) => ch.consume(queue, (msg) => cb(msg.content.toString()))
  }};
}}

module.exports = initRabbit;
  ]],
			{}
		)
	),
}
