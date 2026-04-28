local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"lru",
		fmt(
			[[
public class LruCache<TKey, TValue>
{{
    private readonly int _capacity;
    private readonly ConcurrentDictionary<TKey, LinkedListNode<(TKey key, TValue val)>> _map = new();
    private readonly LinkedList<(TKey key, TValue val)> _list = new();
    private readonly object _lock = new();

    public LruCache(int capacity) => _capacity = capacity;

    public TValue GetOrAdd(TKey key, Func<TValue> factory)
    {{
        if (_map.TryGetValue(key, out var node))
        {{
            lock (_lock)
            {{
                _list.Remove(node);
                _list.AddFirst(node);
                return node.Value.val;
            }}
        }}

        var value = factory();
        lock (_lock)
        {{
            var newNode = new LinkedListNode<(TKey, TValue)>((key, value));
            _list.AddFirst(newNode);
            _map[key] = newNode;

            if (_map.Count > _capacity)
            {{
                var last = _list.Last!;
                _list.RemoveLast();
                _map.TryRemove(last.Value.key, out _);
            }}

            return value;
        }}
    }}
}}
  ]],
			{}
		)
	),
}
