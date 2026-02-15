-- Allow resizing DBUI window width.
vim.opt_local.winfixwidth = false

-- Allow resizing DBUI window height.
vim.opt_local.winfixheight = false

-- Reuse Ctrl-p + o behavior from classic Vim DBUI mapping.
vim.keymap.set('n', 'x', '<C-p>o', { buffer = true, silent = true, remap = true })

-- Remove Ctrl-j mapping in DBUI buffer.
pcall(vim.keymap.del, 'n', '<C-j>', { buffer = 0 })

-- Remove Ctrl-k mapping in DBUI buffer.
pcall(vim.keymap.del, 'n', '<C-k>', { buffer = 0 })
