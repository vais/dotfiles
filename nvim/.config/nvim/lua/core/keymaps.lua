-- Scroll viewport left by one column.
vim.keymap.set({ 'n', 'x', 'o' }, '<C-h>', 'zh')

-- Scroll viewport right by one column.
vim.keymap.set({ 'n', 'x', 'o' }, '<C-l>', 'zl')

-- A more ergonomic mapping for returning to a previous jump location.
vim.keymap.set('n', 'gr', '<C-o>', { nowait = true })

-- Go to file in a vertical split.
vim.keymap.set({ 'n', 'x' }, '<C-w>f', '<Cmd>vertical wincmd f<CR>')
vim.keymap.set({ 'n', 'x' }, '<C-w>F', '<Cmd>vertical wincmd F<CR>')

-- Make <C-w><BS> close current window like <C-w>c.
vim.keymap.set('n', '<C-w><BS>', '<C-w>c', { silent = true })
vim.keymap.set('n', '<C-w><C-BS>', '<C-w>c', { silent = true })

-- Make new buffer in a vertical split.
vim.keymap.set('n', '<C-w>n', '<Cmd>vertical new<CR>', { silent = true })

-- Make all windows equally wide.
vim.keymap.set('n', '<C-w><Space>', '<Cmd>horizontal wincmd =<CR>', { silent = true })
vim.keymap.set('n', '<C-w><C-Space>', '<Cmd>horizontal wincmd =<CR>', { silent = true })

-- Make all windows equally tall.
vim.keymap.set('n', '<C-w>=', '<Cmd>vertical wincmd =<CR>', { silent = true })
vim.keymap.set('n', '<C-w><C-=>', '<Cmd>vertical wincmd =<CR>', { silent = true })

-- Expand %% on the command line to the current file's directory path.
vim.keymap.set('c', '%%', function()
  return vim.fn.expand('%:p:h')
end, { expr = true })

-- Indent or de-indent the full current visual-line selection.
vim.keymap.set('x', '<Tab>', 'VVgv>gv', { silent = true })
vim.keymap.set('x', '<S-Tab>', 'VVgv<gv', { silent = true })

-- Shortcut to create a new tab.
vim.keymap.set('n', '<C-w>a', '<Cmd>tabnew<CR>', { silent = true })
vim.keymap.set('n', '<C-w><C-a>', '<Cmd>tabnew<CR>', { silent = true })
vim.keymap.set('n', '<C-w>A', '<Cmd>-1tabnew<CR>', { silent = true })

-- Move current window to its own tab and position it left.
vim.keymap.set('n', '<C-w>m', '<Cmd>wincmd v | wincmd T | silent! tabmove -1<CR>', { silent = true })
vim.keymap.set('n', '<C-w><C-m>', '<Cmd>wincmd v | wincmd T | silent! tabmove -1<CR>', { silent = true })
vim.keymap.set('n', '<C-w>M', '<Cmd>wincmd v | wincmd T<CR>', { silent = true })

-- Quickfix window mappings.
vim.keymap.set('n', '<Leader>co', '<Cmd>botright copen<CR>', { silent = true })
vim.keymap.set('n', '<Leader>cq', '<Cmd>cclose<CR>', { silent = true })
vim.keymap.set('n', '<Leader>cc', '<Cmd>cc<CR>', { silent = true })
vim.keymap.set('n', '<Leader>ct', [[<Cmd>Qfilter!\V\<tests\?\>\C<CR>]], { silent = true })
vim.keymap.set('n', '<Leader>cT', [[<Cmd>Qfilter\V\<tests\?\>\C<CR>]], { silent = true })

-- Tab navigation mappings.
vim.keymap.set('n', '[t', '<Cmd>tabprevious<CR>', { silent = true })
vim.keymap.set('x', '[t', '<Cmd>tabprevious<CR>', { silent = true })

vim.keymap.set('n', '[T', '<Cmd>tabfirst<CR>', { silent = true })
vim.keymap.set('x', '[T', '<Cmd>tabfirst<CR>', { silent = true })

vim.keymap.set('n', ']t', '<Cmd>tabnext<CR>', { silent = true })
vim.keymap.set('x', ']t', '<Cmd>tabnext<CR>', { silent = true })

vim.keymap.set('n', ']T', '<Cmd>tablast<CR>', { silent = true })
vim.keymap.set('x', ']T', '<Cmd>tablast<CR>', { silent = true })

-- Toggle highlighting of all occurrences of the current search term.
vim.keymap.set('n', 'gh', function()
  vim.opt.hlsearch = not vim.opt.hlsearch:get()
end, { silent = true })

vim.keymap.set('x', 'gh', function()
  vim.opt.hlsearch = not vim.opt.hlsearch:get()
end, { silent = true })

-- Double-tap to append a semicolon at end of line and continue inserting at prior insert position.
vim.keymap.set('i', ';;', '<C-g>u<Esc>A;<Esc>gi<C-g>u', { silent = true })

-- Double-tap to append a comma at end of line and continue inserting at prior insert position.
vim.keymap.set('i', ',,', '<C-g>u<Esc>A,<Esc>gi<C-g>u', { silent = true })

-- Save the current buffer.
vim.keymap.set('n', '<F5>', '<Cmd>write<CR>', { silent = true })

-- Leave insert mode and save the current buffer.
vim.keymap.set('i', '<F5>', '<Esc><Cmd>write<CR>', { silent = true })

-- Map jj to escape insert mode.
vim.keymap.set('i', 'jj', '<Esc>', { silent = true })

-- Map jj to leave terminal-job mode and enter terminal-normal mode.
vim.keymap.set('t', 'jj', '<C-\\><C-n>', { silent = true })

-- Redraw, reload file if changed on disk, resync syntax, and refresh ALE diagnostics.
vim.keymap.set('n', '<Leader>l', '<C-l><Cmd>checktime<CR><Cmd>syntax sync fromstart<CR><Cmd>ALELint<CR>', { silent = true })

-- In command-line mode, make <C-p>/<C-n> navigate completion menu or history.
vim.keymap.set('c', '<C-p>', function()
  if vim.fn.wildmenumode() == 1 then
    return '<C-p>'
  end

  return '<Up>'
end, { expr = true })

vim.keymap.set('c', '<C-n>', function()
  if vim.fn.wildmenumode() == 1 then
    return '<C-n>'
  end

  return '<Down>'
end, { expr = true })

-- Use system clipboard for macOS Command-key cut/copy/paste.
vim.keymap.set('x', '<D-x>', '"+x', { silent = true })
vim.keymap.set('x', '<D-c>', '"+y', { silent = true })
vim.keymap.set('x', '<D-v>', '"+p', { silent = true })
vim.keymap.set('n', '<D-v>', '"+p', { silent = true })
vim.keymap.set('i', '<D-v>', '<C-r>+', { silent = true })
vim.keymap.set('c', '<D-v>', '<C-r>+', { silent = true })
vim.keymap.set('t', '<D-v>', function()
  vim.api.nvim_chan_send(vim.b.terminal_job_id, vim.fn.getreg('+'))
end, { silent = true })
