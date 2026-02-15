local M = {}
local window_picker

local function hl_fg_hex(name)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = true })
  if not ok or not hl or not hl.fg then
    return nil
  end

  return string.format('#%06x', hl.fg)
end

local function minimalist_font()
  return setmetatable({}, {
    __index = function(_, key)
      local ch = tostring(key or ''):sub(1, 1)
      if ch == '' then
        return ' '
      end
      return (' %s '):format(ch:upper())
    end,
  })
end

local function has_open_float_window()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative and config.relative ~= '' then
      return true
    end
  end

  return false
end

local function with_temporary_float_hl(hl, callback)
  local normal_float = vim.api.nvim_get_hl(0, { name = 'NormalFloat', link = false })
  local float_border = vim.api.nvim_get_hl(0, { name = 'FloatBorder', link = false })

  vim.api.nvim_set_hl(0, 'NormalFloat', hl.normal_float)
  vim.api.nvim_set_hl(0, 'FloatBorder', hl.float_border)

  local ok, result = pcall(callback)

  vim.api.nvim_set_hl(0, 'NormalFloat', normal_float)
  vim.api.nvim_set_hl(0, 'FloatBorder', float_border)

  if not ok then
    error(result)
  end

  return result
end

local function pick_window_with_mode_color(prompt, color)
  color = color or 'fg'
  local winid = with_temporary_float_hl({
    normal_float = { fg = color, bg = 'NONE', bold = true },
    float_border = { fg = color, bg = 'NONE', bold = true },
  }, function()
    return window_picker.pick_window({
      hint = 'floating-big-letter',
      prompt_message = prompt,
    })
  end)
  return winid
end

local function focus_window()
  if has_open_float_window() then
    return
  end

  local winid = pick_window_with_mode_color('Focus window: ', hl_fg_hex('Added'))
  if winid and vim.api.nvim_win_is_valid(winid) then
    vim.api.nvim_set_current_win(winid)
  end
end

local function close_window()
  if has_open_float_window() then
    return
  end

  local winid = pick_window_with_mode_color('Close window: ', hl_fg_hex('Removed'))
  if winid and vim.api.nvim_win_is_valid(winid) then
    pcall(vim.api.nvim_win_close, winid, false)
  end
end

function M.setup()
  window_picker = require('window-picker')
  window_picker.setup({
    hint = 'floating-big-letter',
    show_prompt = false,
    picker_config = {
      handle_mouse_click = false,
      floating_big_letter = {
        font = minimalist_font(),
      },
    },
    filter_rules = {
      autoselect_one = false,
      include_current_win = true,
      include_unfocusable_windows = false,
      bo = {
        filetype = { 'NvimTree', 'neo-tree', 'notify', 'snacks_notif' },
        buftype = { 'acwrite' },
      },
      wo = {},
    },
  })

  -- Pick a window to focus.
  vim.keymap.set('n', '<C-w>;', focus_window, { silent = true })

  -- Pick a window to close.
  vim.keymap.set('n', '<C-w>,', close_window, { silent = true })
end

return M
