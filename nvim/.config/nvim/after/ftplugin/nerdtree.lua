-- Allow resizing NERDTree windows freely.
vim.opt_local.winfixwidth = false

-- Allow resizing NERDTree window height freely.
vim.opt_local.winfixheight = false

-- Unmap Ctrl-j in NERDTree buffer.
pcall(vim.keymap.del, 'n', '<C-j>', { buffer = 0 })

-- Unmap Ctrl-k in NERDTree buffer.
pcall(vim.keymap.del, 'n', '<C-k>', { buffer = 0 })
