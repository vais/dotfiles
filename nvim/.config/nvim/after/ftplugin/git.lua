local function set_diff_context(delta)
  local context = vim.b.git_diff_opts_context or 3

  context = math.max(context + delta, 3)

  vim.b.git_diff_opts_context = context

  vim.env.GIT_DIFF_OPTS = '--unified=' .. context

  vim.cmd('edit')

  vim.env.GIT_DIFF_OPTS = ''
end

-- Start with folds closed in git buffers.
vim.opt_local.foldlevel = 0

-- Build folds from syntax regions.
vim.opt_local.foldmethod = 'syntax'

-- Use the default fold text formatter.
vim.opt_local.foldtext = 'foldtext()'

-- Toggle fold under cursor.
vim.keymap.set('n', '-', 'za', { buffer = true, silent = true, remap = true })

-- Toggle fold under cursor without waiting for further key sequence.
vim.keymap.set('n', '=', 'za', { buffer = true, silent = true, remap = true, nowait = true })

-- Move to next hunk and open it.
vim.keymap.set('n', '<C-n>', 'zm]mza', { buffer = true, silent = true, remap = true })

-- Move to previous hunk and open it.
vim.keymap.set('n', '<C-p>', 'zm[mza', { buffer = true, silent = true, remap = true })

-- Increase inline diff context and reopen around cursor.
vim.keymap.set('n', '<C-a>', function()
  set_diff_context(1)

  vim.cmd('normal! zv')
end, { buffer = true, silent = true })

-- Decrease inline diff context and reopen around cursor.
vim.keymap.set('n', '<C-x>', function()
  set_diff_context(-1)

  vim.cmd('normal! zv')
end, { buffer = true, silent = true })
