local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"mpsc",
		fmt(
			[[
public class MpscQueue<T>
{{
    class Node {{ public T Value; public Node Next; }}

    private Node _head;
    private Node _tail;

    public MpscQueue()
    {{
        _head = _tail = new Node();
    }}

    public void Enqueue(T item)
    {{
        var node = new Node {{ Value = item }};
        var prev = Interlocked.Exchange(ref _head, node);
        prev.Next = node;
    }}

    public bool TryDequeue(out T result)
    {{
        var tail = _tail;
        var next = tail.Next;
        if (next == null)
        {{
            result = default!;
            return false;
        }}

        result = next.Value;
        _tail = next;
        return true;
    }}
}}
  ]],
			{}
		)
	),
}
