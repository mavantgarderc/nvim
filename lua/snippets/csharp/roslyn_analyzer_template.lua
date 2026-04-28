local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"roslynan",
		fmt(
			[[
[DiagnosticAnalyzer(LanguageNames.CSharp)]
public class {name} : DiagnosticAnalyzer
{{
    public static readonly DiagnosticDescriptor Rule = new(
        id: "{id}",
        title: "{title}",
        messageFormat: "{msg}",
        category: "{category}",
        defaultSeverity: DiagnosticSeverity.Warning,
        isEnabledByDefault: true);

    public override ImmutableArray<DiagnosticDescriptor> SupportedDiagnostics
        => ImmutableArray.Create(Rule);

    public override void Initialize(AnalysisContext context)
    {{
        context.ConfigureGeneratedCodeAnalysis(GeneratedCodeAnalysisFlags.None);
        context.EnableConcurrentExecution();

        context.RegisterSyntaxNodeAction(Analyze, SyntaxKind.ClassDeclaration);
    }}

    private void Analyze(SyntaxNodeAnalysisContext ctx)
    {{
        // Insert logic
    }}
}}
  ]],
			{
				name = ls.insert_node(1, "MyAnalyzer"),
				id = ls.insert_node(2, "MY0001"),
				title = ls.insert_node(3, "My Analyzer Rule"),
				msg = ls.insert_node(4, "Class violates rule"),
				category = ls.insert_node(5, "Design"),
			}
		)
	),
}
