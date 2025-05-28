local function show_keymaps_with_functions()
  local buf = vim.api.nvim_create_buf(false, true)
  local split_width = 60

  vim.cmd('vertical rightbelow split')
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_width(win, split_width)

  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_buf_set_name(buf, 'Neovim Keymaps')
  vim.api.nvim_buf_set_option(buf, 'filetype', 'keymap-help')
  vim.api.nvim_buf_set_option(buf, 'modifiable', true)

  local lines = {}
  local modes = { 'n', 'i', 'v', 'x', 's', 'o', 't', 'c' }

  -- Add header with instructions
  table.insert(lines, "NEOVIM KEYMAPS (λ = Lua function reference)")
  table.insert(lines, string.rep("─", split_width - 1))
  table.insert(lines, "Use :lua require('debug').getinfo(<function>) on references")
  table.insert(lines, "")

  -- Cache for tracking repeated functions
  local func_refs = {}
  local current_ref = 1

  -- Function to extract Lua function address from the rhs
  local function extract_lua_function_address(rhs)
    local func_addr = tostring(load(rhs)):match("function: (%x+)")
    if func_addr then
      if not func_refs[func_addr] then
        func_refs[func_addr] = current_ref
        current_ref = current_ref + 1
      end
      return string.format("λ#%d (0x%s)", func_refs[func_addr], func_addr)
    end
    return ""
  end

  for _, mode in ipairs(modes) do
    local keymaps = vim.api.nvim_get_keymap(mode)

    if #keymaps > 0 then
      table.insert(lines, string.format("🅝 %s MODE", string.upper(mode)))
      table.insert(lines, string.rep("─", split_width - 1))

      for _, keymap in ipairs(keymaps) do
        local action = keymap.desc or ""
        local func_ref = ""

        -- Check for Lua function in rhs and extract its address
        if keymap.rhs then
          func_ref = extract_lua_function_address(keymap.rhs)
        end

        -- Format the line
        local formatted_line = string.format(
          "[%s] %-20s → %s",
          mode,
          keymap.lhs,
          action ~= "" and action or (keymap.rhs or func_ref)
        )

        table.insert(lines, formatted_line)
      end
      table.insert(lines, "")
    end
  end

  -- Add function reference legend
  table.insert(lines, string.rep("─", split_width - 1))
  table.insert(lines, "FUNCTION REFERENCES:")
  for addr, ref in pairs(func_refs) do
    table.insert(lines, string.format("λ#%d → 0x%s", ref, addr))
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)

  -- Syntax highlighting
  vim.cmd [[
    syntax match KeymapFuncRef /λ#\d\+/
    highlight link KeymapFuncRef Special
  ]]

  -- Navigation mappings
  vim.keymap.set('n', 'q', '<CMD>q<CR>', { buffer = buf })
  vim.keymap.set('n', '?', function()
    print("Use :lua require('debug').getinfo(vim.fn.input('Function: ')) to inspect")
  end, { buffer = buf })
end

vim.api.nvim_create_user_command('Km', show_keymaps_with_functions, {})
