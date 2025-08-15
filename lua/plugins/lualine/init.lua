return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "lewis6991/gitsigns.nvim",
  },
  event = "VeryLazy",
  config = function()
    local components = require("plugins.lualine.components")
    local utils = require("plugins.lualine.utils")
    local autocmds = require("plugins.lualine.autocmds")
    local keymaps = require("plugins.lualine.keymaps")

    local opts = {
      options = {
        icons_enabled        = true,
        theme                = utils.get_theme(),
        component_separators = { left = "", right = "" },
        section_separators   = { left = "", right = "" },
        disabled_filetypes   = { statusline = { "alpha", "dashboard", "lazy", "TelescopePrompt" } },
        always_divide_middle = true,
        always_show_tabline  = true,
        globalstatus         = false,
        refresh              = { statusline = 5000, tabline = 5000, winbar = 5000 },
      },
      sections = {
        lualine_a = { components.branch },
        lualine_b = { components.diagnostics },
        lualine_c = {
          {
            components.get_navic_breadcrumbs,
            cond = function()
              return require("plugins.lualine.utils").has_value(
                components.get_navic_breadcrumbs)
            end
          },
          {
            components.get_current_symbol,
            cond = function()
              return require("plugins.lualine.utils").has_value(
                components.get_current_symbol)
            end
          },
        },
        lualine_x = { components.diff, components.filetype },
        lualine_y = { components.location },
        lualine_z = { components.progress },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = { components.progress },
      },
      tabline = {
        lualine_a = { "tabs" },
        lualine_b = { utils.get_cwd },
        lualine_c = { "filename" },
        lualine_y = {
          { components.get_lsp_clients,     cond = utils.has_lsp },
          { components.get_python_env,      cond = function() return utils.has_value(components.get_python_env) end },
          { components.get_dotnet_project,  cond = function() return utils.has_value(components.get_dotnet_project) end },
          { components.get_test_status,     cond = function() return utils.has_value(components.get_test_status) end },
          { components.get_debug_status,    cond = function() return utils.has_value(components.get_debug_status) end },
          { components.get_database_status, cond = utils.is_sql_file },
          components.get_file_info,
        },
        lualine_z = {},
      },
    }

    require("lualine").setup(opts)
    autocmds.setup(opts)
    keymaps.setup(opts)
  end,
}
