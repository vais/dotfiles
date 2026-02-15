local function open_quickfix_entry(open_target_cmd, preserve_qf_as_previous)
  local qf_win = vim.api.nvim_get_current_win()
  local qf_line = vim.fn.line('.')

  -- Jump to the file window associated with this quickfix list.
  vim.cmd('wincmd p')

  -- Create the requested destination for opening the entry.
  vim.cmd(open_target_cmd)

  -- Open the selected quickfix entry in the destination window.
  vim.cmd(string.format('cc %d', qf_line))

  if preserve_qf_as_previous then
    local target_win = vim.api.nvim_get_current_win()

    -- Make quickfix the previous window for the new split.
    if vim.api.nvim_win_is_valid(qf_win) then
      vim.api.nvim_set_current_win(qf_win)
      vim.api.nvim_set_current_win(target_win)
    end
  end
end

-- Allow resizing quickfix window width.
vim.opt_local.winfixwidth = false

-- Allow resizing quickfix window height.
vim.opt_local.winfixheight = false

-- Close quickfix and return to previous window.
vim.keymap.set('n', '<Leader>cq', '<Cmd>wincmd p | cclose<CR>', { buffer = true, silent = true })

-- Open the selected quickfix entry in a vertical split.
vim.keymap.set('n', '<C-w><CR>', function()
  open_quickfix_entry('vertical split', true)
end, { buffer = true, silent = true })

-- Match Enter keycode variants from some terminals.
vim.keymap.set('n', '<C-w><Enter>', function()
  open_quickfix_entry('vertical split', true)
end, { buffer = true, silent = true })

-- Open the selected quickfix entry in a horizontal split.
vim.keymap.set('n', '<C-w><C-Enter>', function()
  open_quickfix_entry('split', true)
end, { buffer = true, silent = true })

-- Match Ctrl-Enter keycode variants from some terminals.
vim.keymap.set('n', '<C-w><C-j>', function()
  open_quickfix_entry('split', true)
end, { buffer = true, silent = true })

-- Open the selected quickfix entry in a new tab.
vim.keymap.set('n', '<C-w><Tab>', function()
  open_quickfix_entry('tab split', false)
end, { buffer = true, silent = true })

-- Match Tab keycode variants from some terminals.
vim.keymap.set('n', '<C-w><C-i>', function()
  open_quickfix_entry('tab split', false)
end, { buffer = true, silent = true })
