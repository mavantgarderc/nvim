-- lua/Raphael/picker.lua
-- Raphael picker with palette floating window, fuzzy search, collapsible categories

local themes = require("Raphael.themes")
local M = {}

-- buffers/windows
local picker_buf, picker_win
local palette_buf, palette_win
local search_buf, search_win

-- core state
local core_ref, state_ref
local previewed
local collapsed = {}
local bookmarks = {}
local search_query = ""

-- icons
local ICON_BOOKMARK   = ""
local ICON_CURRENT_ON = ""
local ICON_CURRENT_OFF= ""
local ICON_GROUP_EXP  = ""
local ICON_GROUP_COL  = ""
local BLOCK_CHAR      = "▇"
local ICON_SEARCH     = ""

-- highlight groups for palette
local PALETTE_HL = { "Normal", "Comment", "String", "Identifier", "Function", "Type" }

-- helpers
local function trim(s) return (s or ""):gsub("^%s+", ""):gsub("%s+$", "") end
local function int_to_hex(n) if type(n)~="number" then return nil end return string.format("#%06x", n) end

-- parse line for theme name
local function parse_line_theme(line)
  if not line or line=="" then return nil end
  if line:match("%(%d+%)%s*$") then return nil end
  local theme = line:match("([%w_%-]+)%s*$")
  if theme and theme~="" then return theme end
  local last
  for token in line:gmatch("%S+") do last=token end
  if last then last = last:gsub("^[^%w_%-]+",""):gsub("[^%w_%-]+$","") end
  return last
end

-- debounce
local function debounce(ms, fn)
  local timer = nil
  return function(...)
    local args = {...}
    if timer then pcall(vim.loop.timer_stop,timer); pcall(vim.loop.close,timer); timer=nil end
    timer = vim.defer_fn(function() pcall(fn, unpack(args)); timer=nil end, ms)
  end
end

-- palette highlights cache
local palette_hl_cache = {}
local function ensure_palette_hl(idx, hex)
  if not hex then return nil end
  local name = ("RaphaelPalette%d_%s"):format(idx, hex:gsub("#",""))
  if palette_hl_cache[name] then return name end
  pcall(vim.api.nvim_set_hl,0,name,{bg=hex})
  palette_hl_cache[name]=true
  return name
end

-- create/update palette floating window
function M.update_palette(theme)
  if not theme or not themes.is_available(theme) then
    if palette_win and vim.api.nvim_win_is_valid(palette_win) then pcall(vim.api.nvim_win_close,palette_win,true) end
    palette_win, palette_buf=nil,nil
    return
  end

  if not picker_win or not vim.api.nvim_win_is_valid(picker_win) then return end

  if not palette_buf or not vim.api.nvim_buf_is_valid(palette_buf) then
    palette_buf = vim.api.nvim_create_buf(false,true)
    vim.api.nvim_buf_set_option(palette_buf,"buftype","nofile")
    vim.api.nvim_buf_set_option(palette_buf,"bufhidden","wipe")
    vim.api.nvim_buf_set_option(palette_buf,"modifiable",false)
  end

  -- line of blocks
  local blocks={}
  for i=1,#PALETTE_HL do blocks[i]=BLOCK_CHAR end
  local palette_line=table.concat(blocks," ")
  pcall(vim.api.nvim_buf_set_option,palette_buf,"modifiable",true)
  pcall(vim.api.nvim_buf_set_lines,palette_buf,0,-1,false,{palette_line})
  pcall(vim.api.nvim_buf_set_option,palette_buf,"modifiable",false)

  -- highlight
  local bufline = (vim.api.nvim_buf_get_lines(palette_buf,0,1,false) or {""})[1] or ""
  for i,hl_name in ipairs(PALETTE_HL) do
    local ok,hl=pcall(vim.api.nvim_get_hl,0,{name=hl_name})
    if ok and hl then
      local hex=int_to_hex(hl.bg or hl.fg)
      if hex then
        local gname=ensure_palette_hl(i,hex)
        local pos=nil
        local count=0
        local pos = nil
        local count = 0
        for i = 1, #bufline do
          local ch = bufline:sub(i,i)
          if ch == BLOCK_CHAR then
            count = count + 1
            if count == i then
              pos = i - 1
              break
            end
          end
        end
        if pos then pcall(vim.api.nvim_buf_add_highlight,palette_buf,0,gname,0,pos,pos+1) end
      end
    end
  end

  -- open/update floating window above picker
  local cfg=vim.api.nvim_win_get_config(picker_win)
  local p_width=(type(cfg.width)=="table" and cfg.width[false] or cfg.width) or 0
  local p_row=(type(cfg.row)=="table" and cfg.row[false] or cfg.row) or 0
  local p_col=(type(cfg.col)=="table" and cfg.col[false] or cfg.col) or 0
  local pal_row = math.max(p_row-1,0)
  local pal_col = 0
  local pal_width=p_width

  if palette_win and vim.api.nvim_win_is_valid(palette_win) then
    pcall(vim.api.nvim_win_set_buf,palette_win,palette_buf)
    pcall(vim.api.nvim_win_set_config,palette_win,{
      relative="editor",width=pal_width,height=1,row=pal_row,col=pal_col,style="minimal",border="rounded",
    })
  else
    palette_win=vim.api.nvim_open_win(palette_buf,false,{
      relative="editor",width=pal_width,height=1,row=pal_row,col=pal_col,style="minimal",border="rounded",zindex=50
    })
  end
end

-- render picker
local function render()
  if not picker_buf or not vim.api.nvim_buf_is_valid(picker_buf) then return end
  local lines={}
  for group,items in pairs(themes.theme_map) do
    local visible_count=0
    for _,t in ipairs(items) do
      if search_query=="" or (t:lower():find(search_query:lower(),1,true)) then visible_count=visible_count+1 end
    end
    local header_icon=collapsed[group] and ICON_GROUP_COL or ICON_GROUP_EXP
    local sum=collapsed[group] and string.format("(%d themes hidden)",#items) or string.format("(%d)",#items)
    table.insert(lines,string.format("%s %s %s",header_icon,group,sum))
    if not collapsed[group] then
      for _,t in ipairs(items) do
        if search_query=="" or t:lower():find(search_query:lower(),1,true) then
          local b=bookmarks[t] and ICON_BOOKMARK or " "
          local s=(state_ref and state_ref.current==t) and ICON_CURRENT_ON or ICON_CURRENT_OFF
          table.insert(lines,string.format("  %s %s %s",b,s,t))
        end
      end
    end
  end
  pcall(vim.api.nvim_buf_set_option,picker_buf,"modifiable",true)
  pcall(vim.api.nvim_buf_set_lines,picker_buf,0,-1,false,lines)
  pcall(vim.api.nvim_buf_set_option,picker_buf,"modifiable",false)
end

-- close everything
local function close_picker(revert)
  if revert and state_ref and state_ref.previous and themes.is_available(state_ref.previous) then pcall(vim.cmd.colorscheme,state_ref.previous) end
  if picker_win and vim.api.nvim_win_is_valid(picker_win) then pcall(vim.api.nvim_win_close,picker_win,true) end
  if palette_win and vim.api.nvim_win_is_valid(palette_win) then pcall(vim.api.nvim_win_close,palette_win,true) end
  if search_win and vim.api.nvim_win_is_valid(search_win) then pcall(vim.api.nvim_win_close,search_win,true) end
  picker_buf,picker_win,palette_buf,palette_win,search_buf,search_win=nil,nil,nil,nil,nil,nil
  search_query=""
  previewed=nil
end

-- ensure picker buffer
local function ensure_picker_buf()
  if picker_buf and vim.api.nvim_buf_is_valid(picker_buf) then return end
  picker_buf=vim.api.nvim_create_buf(false,true)
  vim.api.nvim_buf_set_option(picker_buf,"bufhidden","wipe")
  vim.api.nvim_buf_set_option(picker_buf,"buftype","nofile")
  vim.api.nvim_buf_set_option(picker_buf,"filetype","raphael_picker")
end

-- debounced preview
local function do_preview(theme)
  if not theme or not themes.is_available(theme) then return end
  if previewed==theme then return end
  previewed=theme
  pcall(vim.cmd.colorscheme,theme)
  pcall(M.update_palette,theme)
end
local preview=debounce(100,do_preview)

-- open picker
function M.open(core)
  core_ref=core
  state_ref=core.state
  bookmarks={}
  for _,b in ipairs(state_ref.bookmarks or {}) do bookmarks[b]=true end
  collapsed=type(state_ref.collapsed)=="table" and vim.deepcopy(state_ref.collapsed) or {}

  ensure_picker_buf()
  local total_h=math.max(6,math.floor(vim.o.lines*0.6))
  local picker_w=math.floor(vim.o.columns*0.5)
  local picker_row=math.floor((vim.o.lines-total_h)/2)
  local picker_col=math.floor((vim.o.columns-picker_w)/2)

  picker_win=vim.api.nvim_open_win(picker_buf,true,{
    relative="editor",width=picker_w,height=total_h,row=picker_row,col=picker_col,
    style="minimal",border="rounded",title="Raphael"
  })

  state_ref.previous=vim.g.colors_name

  -- keymaps
  vim.keymap.set("n", "q", function() close_picker(true) end, {buffer=picker_buf})
  vim.keymap.set("n","<Esc>",function() close_picker(true) end,{buffer=picker_buf})

  -- collapse toggle
  vim.keymap.set("n","<CR>",function()
    local line=vim.api.nvim_get_current_line()
    local hdr=line:match("^%s*[]%s*(.+)%s*%(")
    if hdr then
      collapsed[hdr]=not collapsed[hdr]
      state_ref.collapsed=vim.deepcopy(collapsed)
      if core_ref and core_ref.save_state then pcall(core_ref.save_state) end
      render()
      return
    end
    -- otherwise apply theme
    local theme=parse_line_theme(line)
    if theme and themes.is_available(theme) then
      if core_ref and core_ref.apply then pcall(core_ref.apply,theme) end
      state_ref.current=theme
      if core_ref and core_ref.save_state then pcall(core_ref.save_state) end
      close_picker(false)
    else
      vim.notify("Raphael: no theme on this line",vim.log.levels.INFO)
    end
  end,{buffer=picker_buf})

  -- bookmarks toggle
  vim.keymap.set("n",core_ref.config.leader.."b",function()
    local line=vim.api.nvim_get_current_line()
    local theme=parse_line_theme(line)
    if not theme then return end
    bookmarks[theme]=not bookmarks[theme]
    local arr={}
    for t,_ in pairs(bookmarks) do table.insert(arr,t) end
    state_ref.bookmarks=arr
    if core_ref and core_ref.save_state then pcall(core_ref.save_state) end
    render()
    pcall(M.update_palette,state_ref.current)
  end,{buffer=picker_buf})

  -- cursor moved
  vim.api.nvim_create_autocmd({"CursorMoved","CursorMovedI"},{buffer=picker_buf,callback=function()
    local line=vim.api.nvim_get_current_line()
    local theme=parse_line_theme(line)
    preview(theme)
  end})

  -- search
  vim.keymap.set("n","/",function()
    if not search_buf or not vim.api.nvim_buf_is_valid(search_buf) then
      search_buf=vim.api.nvim_create_buf(false,true)
      search_win=vim.api.nvim_open_win(search_buf,true,{
        relative="win",win=picker_win,width=picker_w,height=1,row=vim.api.nvim_win_get_height(picker_win)-1,col=0,style="minimal",border="rounded"
      })
      vim.fn.prompt_setprompt(search_buf,ICON_SEARCH.." ")
      vim.cmd("startinsert")
      vim.api.nvim_create_autocmd({"TextChangedI","TextChanged"},{buffer=search_buf,callback=function()
        local lines=vim.api.nvim_buf_get_lines(search_buf,0,-1,false)
        local q=table.concat(lines,"\n"):gsub("^"..ICON_SEARCH.." ","")
        search_query=trim(q)
        render()
      end})
      vim.keymap.set("i","<Esc>",function()
        if search_win and vim.api.nvim_win_is_valid(search_win) then pcall(vim.api.nvim_win_close,search_win,true) end
        search_buf,search_win=nil,nil
        vim.cmd("stopinsert")
      end,{buffer=search_buf})
      vim.keymap.set("i","<CR>",function()
        if search_win and vim.api.nvim_win_is_valid(search_win) then pcall(vim.api.nvim_win_close,search_win,true) end
        search_buf,search_win=nil,nil
        vim.cmd("stopinsert")
      end,{buffer=search_buf})
      vim.keymap.set("i","<C-l>",function()
        search_query=""
        render()
      end,{buffer=search_buf})
    end
  end,{buffer=picker_buf})

  render()
  M.update_palette(state_ref.current)
end

return M
