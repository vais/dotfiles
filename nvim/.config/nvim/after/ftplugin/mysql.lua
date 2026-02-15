-- Use vim-dadbod completion for SQL omni completion.
vim.opt_local.omnifunc = 'vim_dadbod_completion#omni'

-- Complete to next item when menu is visible, otherwise start omni completion.
vim.keymap.set('i', '<C-@>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-n>'
  end

  return '<C-x><C-o>'
end, { buffer = true, expr = true, silent = true })

-- Match Ctrl-Space keycode variants for omni completion.
vim.keymap.set('i', '<C-Space>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-n>'
  end

  return '<C-x><C-o>'
end, { buffer = true, expr = true, silent = true })

-- Format entire buffer as MySQL (requires npm install sql-formatter).
vim.keymap.set('n', '<Leader>F', '<Cmd>%!sql-formatter -l mysql<CR>', { buffer = true, silent = true })

-- Format visual selection as MySQL (requires npm install sql-formatter).
vim.keymap.set('x', '<Leader>F', ":'<,'>!sql-formatter -l mysql<CR>", { buffer = true, silent = true })
