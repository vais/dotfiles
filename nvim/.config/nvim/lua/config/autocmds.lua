-- Keep cursorline enabled only in the active non-terminal editing window.
local last_edit_window_by_tab = {}

local function is_popup_window(win)
  local cfg = vim.api.nvim_win_get_config(win)
  if cfg.relative ~= '' or cfg.focusable == false then
    return true
  end

  return vim.wo[win].previewwindow
end

local function is_edit_window(win)
  if not vim.api.nvim_win_is_valid(win) or is_popup_window(win) then
    return false
  end

  local buf = vim.api.nvim_win_get_buf(win)
  return vim.bo[buf].buftype ~= 'terminal'
end

local function update_active_window_cursorline()
  local tab = vim.api.nvim_get_current_tabpage()
  local current_win = vim.api.nvim_get_current_win()
  local current_is_popup = is_popup_window(current_win)
  local active_win
  local last_edit_window = last_edit_window_by_tab[tab]

  if is_edit_window(current_win) then
    active_win = current_win
    last_edit_window_by_tab[tab] = current_win
  elseif current_is_popup then
    if last_edit_window and vim.api.nvim_win_is_valid(last_edit_window)
        and vim.api.nvim_win_get_tabpage(last_edit_window) == tab
        and is_edit_window(last_edit_window) then
      active_win = last_edit_window
    else
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
        if is_edit_window(win) then
          active_win = win
          last_edit_window_by_tab[tab] = win
          break
        end
      end
    end
  end

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
    if is_popup_window(win) then
      vim.wo[win].cursorline = false
    else
      vim.wo[win].cursorline = win == active_win
    end
  end
end

local cursorline_group = vim.api.nvim_create_augroup('ActiveWindowCursorline', { clear = true })

vim.api.nvim_create_autocmd({ 'VimEnter', 'WinEnter', 'BufWinEnter', 'TabEnter', 'TermOpen', 'TermClose', 'WinClosed' }, {
  group = cursorline_group,
  callback = update_active_window_cursorline,
})

-- Auto-reload file buffers when content changes outside Neovim.
local autoreload_group = vim.api.nvim_create_augroup('AutoReloadBuffer', { clear = true })

vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained' }, {
  group = autoreload_group,
  callback = function(args)
    local buf = args.buf
    if not buf or buf == 0 then
      buf = vim.api.nvim_get_current_buf()
    end

    local name = vim.api.nvim_buf_get_name(buf)
    if vim.bo[buf].buftype == '' and name ~= '' and vim.fn.filereadable(name) == 1 then
      vim.cmd('checktime ' .. buf)
    end
  end,
})

-- Terminal rendering/performance tuning.
local terminal_tuning_group = vim.api.nvim_create_augroup('TerminalTuning', { clear = true })

-- Disable smooth scrolling in all terminal windows.
vim.api.nvim_create_autocmd('TermOpen', {
  group = terminal_tuning_group,
  callback = function()
    vim.opt_local.smoothscroll = false
  end,
})
