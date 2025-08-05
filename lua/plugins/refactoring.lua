-- return {
--   "ThePrimeagen/refactoring.nvim",
--   dependencies = {
--     "nvim-lua/plenary.nvim",
--     "nvim-treesitter/nvim-treesitter",
--   },
--   config = function()
--     require("config.refactoring")
--   end,
-- }

return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local refactoring = require("refactoring")

    refactoring.setup({
      prompt_func_return_type = {
        go = true, java = true, cpp = true, c = true, typescript = true,
      },
      prompt_func_param_type = {
        go = true, java = true, cpp = true, c = true, typescript = true,
      },
      show_success_message = true,
      print_var_statements = {
        javascript = { "console.log(%s)" },
        typescript = { "console.log(%s)" },
        lua        = { "print(vim.inspect(%s))" },
        python     = { "print(%s)" },
        c          = { "printf(\"%s = %%d\\n\", %s);" },
        cpp        = { "std::cout << \"%s = \" << %s << std::endl;" },
        cs         = { "Console.WriteLine(\"%s = %%d\\n\", %s);"}
      },
    })

    -- Optional: Telescope integration
    pcall(function() require("telescope").load_extension("refactoring") end)

    require("core.keymaps.refactoring")
  end
}
