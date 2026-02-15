local M = {}

function M.setup()
  -- Open alternate file.
  vim.keymap.set('n', '<Leader>a', '<Cmd>A<CR>', { silent = true })

  -- Open alternate file in a vertical split.
  vim.keymap.set('n', '<Leader>A', '<Cmd>AV<CR>', { silent = true })
end

return M
