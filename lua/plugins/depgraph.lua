-- ============================================================================
-- Dependency Graph Configuration — plugins/depgraph.lua
-- ============================================================================
-- Visualize project dependencies in a graphical format.
-- ============================================================================

local depgraph = require("depgraph")

-- Configure the depgraph plugin
depgraph.setup({
  -- Set default graph layout style
  layout = "dot",  -- Use Graphviz's 'dot' layout engine (can also try 'neato')
  
  -- Customize appearance
  node_style = {
    shape = "ellipse",  -- Shape of the nodes (options: rectangle, ellipse, etc.)
    color = "lightblue",  -- Node color
    font = "bold",  -- Font style
    font_size = 12,  -- Font size
  },

  -- Path to your dependency graph file (e.g., `package.json`, `requirements.txt`)
  dependency_file = "package.json",  -- Change this depending on your project type

  -- Graph edges: Visual connection between nodes (dependencies)
  edge_style = {
    color = "black",  -- Edge color
    width = 2,        -- Edge width
  },

  -- Actions for navigating the graph
  actions = {
    zoom_in = "<C-+>",  -- Zoom in the graph
    zoom_out = "<C-->", -- Zoom out the graph
    reset_zoom = "<C-0>", -- Reset zoom level
    open_file = "o",    -- Open file on node click
  },
})

-- Keybinding to open the dependency graph visualization
vim.keymap.set("n", "<leader>d", function()
  depgraph.show_graph()
end, { desc = "Show Dependency Graph" })

-- ============================================================================
-- Dependency Graph initialized
-- ============================================================================