local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"chash",
		fmt(
			[[
const crypto = require("crypto");

class ConsistentHashing {{
  constructor(nodes = []) {{
    this.ring = new Map();
    nodes.forEach((n) => this.add(n));
  }}

  hash(key) {{
    return parseInt(
      crypto.createHash("md5").update(key).digest("hex").slice(0, 8),
      16
    );
  }}

  add(node) {{
    const h = this.hash(node);
    this.ring.set(h, node);
    this.rebalance();
  }}

  remove(node) {{
    const h = this.hash(node);
    this.ring.delete(h);
    this.rebalance();
  }}

  rebalance() {{
    this.sorted = Array.from(this.ring.keys()).sort((a, b) => a - b);
  }}

  get(key) {{
    const h = this.hash(key);
    for (const hash of this.sorted) {{
      if (h <= hash) return this.ring.get(hash);
    }}
    return this.ring.get(this.sorted[0]);
  }}
}}

module.exports = ConsistentHashing;
  ]],
			{}
		)
	),
}
