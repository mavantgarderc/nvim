local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "npmlrl",
		name = "NumPy ML Reinforcement Learning Agent Docstring",
		desc = "NumPy-style docstring for a basic RL agent class.",
	}, {
		t({ '"""', "" }),
		i(1, "Q-Learning agent."),
		t({ "", "", "Parameters", "----------" }),
		t({ "", "alpha : float, default=0.1" }),
		t({ "", "    Learning rate." }),
		t({ "", "gamma : float, default=0.99" }),
		t({ "", "    Discount factor." }),
		t({ "", "epsilon : float, default=1.0" }),
		t({ "", "    Exploration rate." }),
		t({ "", "", "Attributes", "----------" }),
		t({ "", "Q : ndarray" }),
		t({ "", "    Q-value table." }),
		t({ "", "", "Methods", "-------" }),
		t({ "", "choose_action(state)" }),
		t({ "", "    Select action using epsilon-greedy policy." }),
		t({ "", "update(state, action, reward, next_state)" }),
		t({ "", "    Update Q-values." }),
		t({ "", '"""' }),
	}),
}
