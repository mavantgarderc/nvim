local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"hkdf",
		fmt(
			[[
public static byte[] HkdfSha256(byte[] ikm, byte[] salt, byte[] info, int length)
{{
    // Extract
    using var hmac = new HMACSHA256(salt);
    var prk = hmac.ComputeHash(ikm);

    // Expand
    var okm = new byte[length];
    Span<byte> t = stackalloc byte[32];
    int offset = 0;
    byte counter = 1;

    using var h = new HMACSHA256(prk);
    Span<byte> prev = Span<byte>.Empty;

    while (offset < length)
    {{
        h.Initialize();
        h.TransformBlock(prev.ToArray(), 0, prev.Length, null, 0);
        h.TransformBlock(info, 0, info.Length, null, 0);
        h.TransformFinalBlock(new[]{ counter }, 0, 1);

        t = h.Hash.AsSpan();
        int copy = Math.Min(32, length - offset);
        t.Slice(0, copy).CopyTo(okm.AsSpan(offset));

        prev = t;
        offset += copy;
        counter++;
    }}

    return okm;
}}
  ]],
			{}
		)
	),
}
