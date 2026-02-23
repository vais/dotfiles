local M = {}

local function is_current_window_float()
  local config = vim.api.nvim_win_get_config(0)
  return config.relative and config.relative ~= ''
end

local function run_coverflow(cmd)
  if is_current_window_float() then
    return
  end

  vim.o.winminwidth = 20

  vim.cmd(cmd)

  vim.o.winminwidth = 1
end

function M.equalize_and_focus_right()
  run_coverflow('horizontal wincmd = | wincmd |')
end

function M.focus_right()
  run_coverflow('wincmd l | wincmd |')
end

function M.focus_left()
  run_coverflow('wincmd h | wincmd |')
end

function M.setup()
  -- Coverflow(tm)-style navigation for splits.
  vim.keymap.set('n', [[<C-w>\]], M.equalize_and_focus_right, { silent = true })
  vim.keymap.set('x', [[<C-w>\]], M.equalize_and_focus_right, { silent = true })

  vim.keymap.set('n', '<C-w><C-\\>', M.equalize_and_focus_right, { silent = true })
  vim.keymap.set('x', '<C-w><C-\\>', M.equalize_and_focus_right, { silent = true })

  vim.keymap.set('n', '<C-w>]', M.focus_right, { silent = true })
  vim.keymap.set('x', '<C-w>]', M.focus_right, { silent = true })

  vim.keymap.set('n', '<C-w><C-]>', M.focus_right, { silent = true })
  vim.keymap.set('x', '<C-w><C-]>', M.focus_right, { silent = true })

  vim.keymap.set('n', '<C-w>[', M.focus_left, { silent = true })
  vim.keymap.set('x', '<C-w>[', M.focus_left, { silent = true })
end

return M
