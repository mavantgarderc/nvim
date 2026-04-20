local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"procstart",
		fmt(
			[[
var psi = new ProcessStartInfo
{{
    FileName = "{cmd}",
    Arguments = "{args}",
    RedirectStandardOutput = true,
    RedirectStandardError = true,
    UseShellExecute = false
}};

using var proc = Process.Start(psi)!;
var output = await proc.StandardOutput.ReadToEndAsync();
var error = await proc.StandardError.ReadToEndAsync();
proc.WaitForExit();
  ]],
			{
				cmd = ls.insert_node(1, "dotnet"),
				args = ls.insert_node(2, "--info"),
			}
		)
	),
}
