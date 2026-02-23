local M = {}

local function get_float_terminals()
  local ok, terminals = pcall(require, 'toggleterm.terminal')
  if not ok then
    return {}
  end

  local all = terminals.get_all(false)
  return vim.tbl_filter(function(term)
    return term.direction == 'float'
  end, all)
end

local function clean_base_name(value)
  if type(value) ~= 'string' then
    return ''
  end

  return value:gsub('^%s+', ''):gsub('%s+$', '')
end

local function set_float_title(term, title)
  if not term.window or not vim.api.nvim_win_is_valid(term.window) then
    return
  end

  local config = vim.api.nvim_win_get_config(term.window)
  if not config.relative or config.relative == '' then
    return
  end

  config.title = title
  config.title_pos = config.title_pos or 'left'
  pcall(vim.api.nvim_win_set_config, term.window, config)
end

local function refresh_float_titles()
  local floats = get_float_terminals()
  local total = #floats

  for index, term in ipairs(floats) do
    local base = clean_base_name(term.display_name)
    local title = string.format(' %s %d/%d ', base, index, total)
    set_float_title(term, title)
  end
end

function M.apply(term)
  local incoming = clean_base_name(term.display_name)
  local base = incoming ~= '' and incoming or 'terminal'
  term.display_name = string.format(' %s ', base)
  refresh_float_titles()
end

function M.clear(term)
  -- No cached per-id state to clear; keep for call-site symmetry.
  vim.schedule(refresh_float_titles)
end

return M
