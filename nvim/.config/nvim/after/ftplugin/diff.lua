-- Build folds from diff section headers.
vim.opt_local.foldmethod = 'expr'

-- Start a new fold on lines beginning with 'diff'.
vim.opt_local.foldexpr = [[getline(v:lnum)=~'^diff'?'>1':1]]

-- Use the default fold text formatter.
vim.opt_local.foldtext = 'foldtext()'

-- Toggle fold under cursor.
vim.keymap.set('n', '-', 'za', { buffer = true, silent = true, remap = true })

-- Toggle fold under cursor without waiting for further key sequence.
vim.keymap.set('n', '=', 'za', { buffer = true, silent = true, remap = true, nowait = true })

-- Move to next folded section and open it.
vim.keymap.set('n', '<C-n>', 'zmzjza', { buffer = true, silent = true, remap = true })

-- Move to previous folded section and open it.
vim.keymap.set('n', '<C-p>', 'zmzkza', { buffer = true, silent = true, remap = true })
