local function maybe_checktime(args)
  local buf = args.buf
  if not buf or buf == 0 then
    buf = vim.api.nvim_get_current_buf()
  end

  local name = vim.api.nvim_buf_get_name(buf)
  if vim.bo[buf].buftype == '' and name ~= '' and vim.fn.filereadable(name) == 1 then
    vim.cmd('checktime ' .. buf)
  end
end

local function tune_terminal_buffer()
  -- Disable smooth scrolling in terminal windows.
  vim.opt_local.smoothscroll = false
end

-- Auto-reload file buffers when content changes outside Neovim.
local auto_reload_group = vim.api.nvim_create_augroup('AutoReloadBuffer', { clear = true })

vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained' }, {
  group = auto_reload_group,
  callback = maybe_checktime,
})

-- Terminal rendering/performance tuning.
local terminal_tuning_group = vim.api.nvim_create_augroup('TerminalTuning', { clear = true })

vim.api.nvim_create_autocmd('TermOpen', {
  group = terminal_tuning_group,
  callback = tune_terminal_buffer,
})
