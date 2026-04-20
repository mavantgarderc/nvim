local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"keyrot",
		fmt(
			[[
public class KeyRotation
{{
    private readonly List<byte[]> _keys = new();

    public void AddKey(byte[] key) => _keys.Insert(0, key);

    public byte[] Current => _keys[0];

    public bool TryGetAny(Func<byte[], bool> predicate, out byte[]? key)
    {{
        foreach (var k in _keys)
            if (predicate(k))
            {{
                key = k;
                return true;
            }}
        key = null;
        return false;
    }}
}}
  ]],
			{}
		)
	),
}
