local cmd = vim.cmd
local api = vim.api
local fn = vim.fn

local M = {}

local config = {
    patterns = {
        cs = {
            "using%s+([%w%.]+)",
            "#r%s+\"([^\"]+)\"",
            "<%s*Reference%s+Include%s*=%s*\"([^\"]+)\"",
            "<%s*PackageReference%s+Include%s*=%s*\"([^\"]+)\""
        },
        py = {
            "import%s+([%w%.]+)",
            "from%s+([%w%.]+)%s+import",
            "import%s+([%w%.]+)%s+as%s+%w+",
            "from%s+%.([%w%.]+)%s+import"
        },
        js = {
            "import%s+.-%s+from%s+['\"]([^'\"]+)['\"]",
            "import%s+['\"]([^'\"]+)['\"]",
            "require%s*%(['\"]([^'\"]+)['\"]%)",
            "import%s*%(['\"]([^'\"]+)['\"]%)"
        },
        ts = {
            "import%s+.-%s+from%s+['\"]([^'\"]+)['\"]",
            "import%s+['\"]([^'\"]+)['\"]",
            "import%s+type%s+.-%s+from%s+['\"]([^'\"]+)['\"]",
            "import%s*%(['\"]([^'\"]+)['\"]%)"
        },
        lua = {
            "require%s*%(?['\"]([^'\"]+)['\"]%)?",
            "require%s*%(?([%w%.%_%/]+)%)?",
            "dofile%s*%(?['\"]([^'\"]+)['\"]%)?",
            "loadfile%s*%(?['\"]([^'\"]+)['\"]%)?",
            "pcall%s*%(?require%s*,%s*['\"]([^'\"]+)['\"]%)?",
            "local%s+%w+%s*=%s*require%s*%(?['\"]([^'\"]+)['\"]%)?",
            "vim%.cmd%s*%(?['\"]source%s+([^'\"]+)['\"]%)?",
            "vim%.api%.nvim_source%s*%(?['\"]([^'\"]+)['\"]%)?",
            "vim%.api%.nvim_exec_lua%s*%(?['\"]([^'\"]+)['\"]",
            "vim%.api%.nvim_command%s*%(?['\"]source%s+([^'\"]+)['\"]%)?",
            "vim%.api%.nvim_command%s*%(?['\"]luafile%s+([^'\"]+)['\"]%)?",
            "vim%.api%.nvim_command%s*%(?['\"]runtime%s+([^'\"]+)['\"]%)?",
            "vim%.api%.nvim_command%s*%(?['\"]packadd%s+([^'\"]+)['\"]%)?",
            "vim%.api%.nvim_command%s*%(?['\"]Plug%s+['\"]([^'\"]+)['\"]",
            "vim%.api%.nvim_command%s*%(?['\"]Plugin%s+['\"]([^'\"]+)['\"]",
            "vim%.api%.nvim_command%s*%(?['\"]call%s+plug#begin%s*%(?['\"]([^'\"]+)['\"]%)?",
            "vim%.api%.nvim_command%s*%(?['\"]call%s+plug#end%s*%(?%)?",
            "vim%.api%.nvim_command%s*%(?['\"]call%s+vundle#begin%s*%(?['\"]([^'\"]+)['\"]%)?",
            "vim%.api%.nvim_command%s*%(?['\"]call%s+vundle#end%s*%(?%)?",
            "vim%.api%.nvim_command%s*%(?['\"]Bundle%s+['\"]([^'\"]+)['\"]",
            "vim%.api%.nvim_command%s*%(?['\"]NeoBundle%s+['\"]([^'\"]+)['\"]",
            "vim%.api%.nvim_command%s*%(?['\"]Lazy%s+['\"]([^'\"]+)['\"]",
            "vim%.api%.nvim_command%s*%(?['\"]use%s+['\"]([^'\"]+)['\"]",
            "vim%.api%.nvim_command%s*%(?['\"]packer%.use%s+['\"]([^'\"]+)['\"]",
            "vim%.api%.nvim_command%s*%(?['\"]packer%.use%s*%b{}",
            "vim%.api%.nvim_command%s*%(?['\"]packer%.use%s*%({%s*['\"]([^'\"]+)['\"]",
            "vim%.g%.([%w_]+)",
            "vim%.b%.([%w_]+)",
            "vim%.w%.([%w_]+)",
            "vim%.t%.([%w_]+)",
            "vim%.v%.([%w_]+)",
            "vim%.env%.([%w_]+)",
            "vim%.o%.([%w_]+)",
            "vim%.bo%.([%w_]+)",
            "vim%.wo%.([%w_]+)",
            "vim%.go%.([%w_]+)"
        },
        sql = {
            "EXEC%s+([%w%.]+)",
            "EXECUTE%s+([%w%.]+)",
            "CALL%s+([%w%.]+)",
            "USE%s+([%w%.]+)",
            "FROM%s+([%w%.]+)",
            "JOIN%s+([%w%.]+)",
            "INTO%s+([%w%.]+)",
            "UPDATE%s+([%w%.]+)",
            "INSERT%s+INTO%s+([%w%.]+)",
            "DELETE%s+FROM%s+([%w%.]+)",
            "CREATE%s+TABLE%s+([%w%.]+)",
            "ALTER%s+TABLE%s+([%w%.]+)",
            "DROP%s+TABLE%s+([%w%.]+)",
            "CREATE%s+VIEW%s+([%w%.]+)",
            "CREATE%s+PROCEDURE%s+([%w%.]+)",
            "CREATE%s+FUNCTION%s+([%w%.]+)"
        },
        html = {
            "src%s*=%s*['\"]([^'\"]+)['\"]",
            "href%s*=%s*['\"]([^'\"]+)['\"]",
            "action%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*script%s+.-%s+src%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*link%s+.-%s+href%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*img%s+.-%s+src%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*iframe%s+.-%s+src%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*form%s+.-%s+action%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*a%s+.-%s+href%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*audio%s+.-%s+src%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*video%s+.-%s+src%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*source%s+.-%s+src%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*track%s+.-%s+src%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*embed%s+.-%s+src%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*object%s+.-%s+data%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*param%s+.-%s+value%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*area%s+.-%s+href%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*base%s+.-%s+href%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*meta%s+.-%s+content%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*input%s+.-%s+src%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*button%s+.-%s+formaction%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*menuitem%s+.-%s+icon%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*command%s+.-%s+icon%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*blockquote%s+.-%s+cite%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*q%s+.-%s+cite%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*del%s+.-%s+cite%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*ins%s+.-%s+cite%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*html%s+.-%s+manifest%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*head%s+.-%s+profile%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*body%s+.-%s+background%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*table%s+.-%s+background%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*tr%s+.-%s+background%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*td%s+.-%s+background%s*=%s*['\"]([^'\"]+)['\"]",
            "<%s*th%s+.-%s+background%s*=%s*['\"]([^'\"]+)['\"]",
            "@import%s+url%s*%(['\"]([^'\"]+)['\"]%)",
            "@import%s+['\"]([^'\"]+)['\"]",
            "url%s*%(['\"]([^'\"]+)['\"]%)"
        }
    },
    file_extensions = {
        cs = {"cs", "csx"},
        py = {"py", "pyx", "pyi"},
        js = {"js", "jsx", "mjs"},
        ts = {"ts", "tsx"},
        lua = {"lua"},
        sql = {"sql", "mysql", "pgsql", "sqlite", "plsql"},
        html = {"html", "htm", "xhtml", "vue"}
    },
    max_depth = 50,
    circular_deps = {}
}

local icons = {
    cs = "󰌛 ",
    py = "󰌠 ",
    js = "󰌞 ",
    ts = "󰛦 ",
    lua = "󰢱 ",
    sql = "󰆼 ",
    html = "󰌝 ",
    folder = "󰉋 ",
    file = "󰈔 ",
    dependency = "󰌘 ",
    circular = "󰑐 ",
    error = "󰅖 ",
    warning = "󰀪 ",
    info = "󰋼 ",
    tree_branch = "├── ",
    tree_last = "└── ",
    tree_pipe = "│ ",
    tree_space = "     ",
    arrow_right = "→ ",
    arrow_down = "↓ ",
    arrow_up = "↑ ",
    bidirectional = "↔ "
}

local colors = {
    "DiagnosticError",
    "DiagnosticWarn",
    "DiagnosticInfo",
    "DiagnosticHint",
    "String",
    "Number",
    "Boolean",
    "Keyword",
    "Function",
    "Type",
    "Constant",
    "Special",
    "Comment",
    "Identifier"
}

local function get_file_type(filename)
    local ext = filename:match("%.([^%.]+)$")
    if not ext then return nil end
    ext = ext:lower()

    for lang, extensions in pairs(config.file_extensions) do
        for _, file_ext in ipairs(extensions) do
            if ext == file_ext then
                return lang
            end
        end
    end
    return nil
end

local function read_file(filepath)
    local file = io.open(filepath, "r")
    if not file then return nil end
    local content = file:read("*all")
    file:close()
    return content
end

local function extract_dependencies(content, file_type)
    local deps = {}
    local patterns = config.patterns[file_type]
    if not patterns then return deps end

    for _, pattern in ipairs(patterns) do
        for match in content:gmatch(pattern) do
            if match and match ~= "" then
                table.insert(deps, match)
            end
        end
    end

    return deps
end

local function find_files(directory)
    local files = {}
    local handle = io.popen("find '" .. directory .. "' -type f 2>/dev/null")
    if handle then
        for file in handle:lines() do
            local file_type = get_file_type(file)
            if file_type then
                table.insert(files, {
                    path = file,
                    type = file_type,
                    name = file:match("([^/]+)$")
                })
            end
        end
        handle:close()
    end
    return files
end

local function build_dependency_graph(directory)
    local files = find_files(directory)
    local graph = {
        nodes = {},
        edges = {},
        reverse_edges = {},
        metadata = {
            total_files = #files,
            total_dependencies = 0,
            circular_dependencies = {},
            languages = {}
        }
    }

    for _, file in ipairs(files) do
        local content = read_file(file.path)
        if content then
            local deps = extract_dependencies(content, file.type)

            graph.nodes[file.path] = {
                name = file.name,
                type = file.type,
                path = file.path,
                dependencies = deps,
                dependents = {}
            }

            graph.metadata.languages[file.type] = (graph.metadata.languages[file.type] or 0) + 1
            graph.metadata.total_dependencies = graph.metadata.total_dependencies + #deps

            for _, dep in ipairs(deps) do
                if not graph.edges[file.path] then
                    graph.edges[file.path] = {}
                end
                table.insert(graph.edges[file.path], dep)

                if not graph.reverse_edges[dep] then
                    graph.reverse_edges[dep] = {}
                end
                table.insert(graph.reverse_edges[dep], file.path)
            end
        end
    end

    local visited = {}
    local rec_stack = {}

    local function detect_cycles(node, path)
        if rec_stack[node] then
            local cycle_start = nil
            for i, n in ipairs(path) do
                if n == node then
                    cycle_start = i
                    break
                end
            end
            if cycle_start then
                local cycle = {}
                for i = cycle_start, #path do
                    table.insert(cycle, path[i])
                end
                table.insert(cycle, node)
                table.insert(graph.metadata.circular_dependencies, cycle)
            end
            return true
        end

        if visited[node] then
            return false
        end

        visited[node] = true
        rec_stack[node] = true
        table.insert(path, node)

        if graph.edges[node] then
            for _, dep in ipairs(graph.edges[node]) do
                if detect_cycles(dep, path) then
                    return true
                end
            end
        end

        rec_stack[node] = false
        table.remove(path)
        return false
    end

    for node, _ in pairs(graph.nodes) do
        if not visited[node] then
            detect_cycles(node, {})
        end
    end

    return graph
end

local function generate_header()
    return [[
╔═══════════════════════════════════════════════════════════════════════════════╗
║                  --- DEPENDENCY  GRAPH  ANALYZER ---                          ║
╚═══════════════════════════════════════════════════════════════════════════════╝
]]
end

local function generate_network_graph(graph)
    local output = {}

    table.insert(output, generate_header())
    table.insert(output, "")

    table.insert(output, "PROJECT STATISTICS:")
    table.insert(output, "├── Total Files: " .. graph.metadata.total_files)
    table.insert(output, "├── Total Dependencies: " .. graph.metadata.total_dependencies)
    table.insert(output, "├── Circular Dependencies: " .. #graph.metadata.circular_dependencies)
    table.insert(output, "└── Languages Found:")

    local lang_count = 0
    for lang, count in pairs(graph.metadata.languages) do
        lang_count = lang_count + 1
        local icon = icons[lang] or icons.file
        table.insert(output, "    " .. icon .. " " .. lang:upper() .. ": " .. count .. " files")
    end

    table.insert(output, "")

    if #graph.metadata.circular_dependencies > 0 then
        table.insert(output, "CIRCULAR DEPENDENCIES DETECTED:")
        for i, cycle in ipairs(graph.metadata.circular_dependencies) do
            local cycle_str = table.concat(cycle, " → ")
            table.insert(output, "    " .. icons.circular .. " Cycle " .. i .. ": " .. cycle_str)
        end
        table.insert(output, "")
    end

    table.insert(output, "DEPENDENCY NETWORK:")
    table.insert(output, "")

    local processed = {}
    local color_index = 1

    for node_path, node in pairs(graph.nodes) do
        if not processed[node_path] then
            local file_icon = icons[node.type] or icons.file
            local color = colors[((color_index - 1) % #colors) + 1]

            table.insert(output, string.format("┌─ %s %s (%s)", file_icon, node.name, node.type:upper()))
            table.insert(output, string.format("│  Path: %s", node.path))

            if #node.dependencies > 0 then
                table.insert(output, "│")
                table.insert(output, "├─ " .. icons.arrow_right .. " DEPENDENCIES (" .. #node.dependencies .. "):")
                for i, dep in ipairs(node.dependencies) do
                    local is_last = i == #node.dependencies
                    local prefix = is_last and "│  └── " or "│  ├── "
                    table.insert(output, prefix .. icons.dependency .. " " .. dep)
                end
            end

            local dependents = graph.reverse_edges[node_path] or {}
            if #dependents > 0 then
                table.insert(output, "│")
                table.insert(output, "├─ " .. icons.arrow_up .. " DEPENDENTS (" .. #dependents .. "):")
                for i, dep in ipairs(dependents) do
                    local is_last = i == #dependents
                    local prefix = is_last and "│  └── " or "│  ├── "
                    local dep_node = graph.nodes[dep]
                    local dep_name = dep_node and dep_node.name or dep
                    table.insert(output, prefix .. icons.bidirectional .. " " .. dep_name)
                end
            end

            table.insert(output, "└─────────────────────────────────────────────")
            table.insert(output, "")

            processed[node_path] = true
            color_index = color_index + 1
        end
    end

    return table.concat(output, "\n")
end

local function generate_json_output(graph)
    local json_output = {
        metadata = graph.metadata,
        nodes = {},
        edges = {}
    }

    for path, node in pairs(graph.nodes) do
        table.insert(json_output.nodes, {
            id = path,
            name = node.name,
            type = node.type,
            path = node.path,
            dependencies = node.dependencies,
            dependents = graph.reverse_edges[path] or {}
        })
    end

    for source, targets in pairs(graph.edges) do
        for _, target in ipairs(targets) do
            table.insert(json_output.edges, {
                source = source,
                target = target,
                type = "dependency"
            })
        end
    end

    return fn.json_encode(json_output)
end

function M.analyze_dependencies(directory)
    local target_dir = directory or fn.getcwd()

    print("Analyzing dependencies in: " .. target_dir)

    local graph = build_dependency_graph(target_dir)

    local visualization = generate_network_graph(graph)

    cmd("tabnew")
    local buf = vim.api.nvim_get_current_buf()

    api.nvim_buf_set_option(buf, "buftype", "nofile")
    api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    api.nvim_buf_set_option(buf, "swapfile", false)
    api.nvim_buf_set_option(buf, "filetype", "dependencygraph")

    api.nvim_buf_set_name(buf, "Dependency Graph - " .. target_dir:match("([^/]+)$"))

    local lines = {}
    for line in visualization:gmatch("[^\n]*") do
        table.insert(lines, line)
    end
    api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    cmd("syntax match DependencyGraphHeader /^╔.*╗$\\|^║.*║$\\|^╚.*╝$/")
    cmd("syntax match DependencyGraphStats /^.*:\\|^├──.*\\|^└──.*\\|^    .*files$/")
    cmd("syntax match DependencyGraphWarning /^.*:\\|^    .*Cycle.*:/")
    cmd("syntax match DependencyGraphNetwork /^.*:$/")
    cmd("syntax match DependencyGraphNode /^┌─.*\\|^│.*\\|^├─.*\\|^└─.*$/")
    cmd("syntax match DependencyGraphFooter /^═.*═$/")

    cmd("highlight DependencyGraphHeader guifg=#61AFEF gui=bold")
    cmd("highlight DependencyGraphStats guifg=#98C379")
    cmd("highlight DependencyGraphWarning guifg=#E06C75 gui=bold")
    cmd("highlight DependencyGraphNetwork guifg=#C678DD gui=bold")
    cmd("highlight DependencyGraphNode guifg=#ABB2BF")
    cmd("highlight DependencyGraphFooter guifg=#5C6370")

    api.nvim_buf_set_option(buf, "readonly", true)
    api.nvim_buf_set_option(buf, "modifiable", false)

    local json_output = generate_json_output(graph)
    local json_file = target_dir .. "/dependency_graph.json"
    local file = io.open(json_file, "w")
    if file then
        file:write(json_output)
        file:close()
        print("📄 JSON output saved to: " .. json_file)
    end

    print("✅ Dependency analysis complete!")
    print("📊 Found " .. graph.metadata.total_files .. " files with " .. graph.metadata.total_dependencies .. " dependencies")
    if #graph.metadata.circular_dependencies > 0 then
        print("⚠️ " .. #graph.metadata.circular_dependencies .. " circular dependencies detected!")
    end
end

function M.setup()
    api.nvim_create_user_command("DepGraph", function(opts)
        M.analyze_dependencies(opts.args ~= "" and opts.args or nil)
    end, {
        nargs = "?",
        desc = "Analyze project dependencies",
        complete = "dir"
    })

    vim.keymap.set("n", "<leader>dg", function()
        M.analyze_dependencies()
    end, { desc = "Analyze Dependencies (current directory)" })

    vim.keymap.set("n", "<leader>dG", function()
        local dir = vim.fn.input("Directory to analyze: ", vim.fn.getcwd(), "dir")
        if dir ~= "" then
            M.analyze_dependencies(dir)
        end
    end, { desc = "Analyze Dependencies (select directory)" })

    vim.keymap.set("n", "<leader>dj", function()
        local target_dir = vim.fn.getcwd()
        local graph = build_dependency_graph(target_dir)
        local json_output = generate_json_output(graph)

        cmd("tabnew")
        local buf = vim.api.nvim_get_current_buf()
        api.nvim_buf_set_option(buf, "filetype", "json")
        api.nvim_buf_set_name(buf, "dependency_graph.json")

        local lines = {}
        for line in json_output:gmatch("[^\n]*") do
            table.insert(lines, line)
        end
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

        print("📄 JSON dependency graph opened in new tab")
    end, { desc = "Show Dependencies as JSON" })

    print("🚀 Dependency Graph Analyzer loaded!")
    print("📋 Commands: :DepGraph [directory]")
    print("🔑 Keymaps: <leader>dg (current), <leader>dG (select), <leader>dj (JSON)")
end

M.setup()

return M
