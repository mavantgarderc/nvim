local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"lfqueue",
		fmt(
			[[
public class LockFreeRing<T>
{{
    private readonly T[] _buffer;
    private readonly int _mask;
    private long _head;
    private long _tail;

    public LockFreeRing(int size)
    {{
        if ((size & (size - 1)) != 0) throw new ArgumentException("size must be power of 2");
        _buffer = new T[size];
        _mask = size - 1;
    }}

    public bool Enqueue(T item)
    {{
        var tail = Volatile.Read(ref _tail);
        if (tail - Volatile.Read(ref _head) >= _buffer.Length) return false; // full

        _buffer[tail & _mask] = item;
        Volatile.Write(ref _tail, tail + 1);
        return true;
    }}

    public bool TryDequeue(out T item)
    {{
        var head = Volatile.Read(ref _head);
        if (head == Volatile.Read(ref _tail))
        {{
            item = default!;
            return false; // empty
        }}

        item = _buffer[head & _mask]!;
        Volatile.Write(ref _head, head + 1);
        return true;
    }}
}}
  ]],
			{}
		)
	),
}
