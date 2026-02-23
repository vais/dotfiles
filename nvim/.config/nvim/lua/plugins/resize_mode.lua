local M = {}

function M.setup()
  -- Define explicit normal-mode mappings to Resize <Plug> targets.
  -- vim-resize-mode checks hasmapto(<Plug>...) before installing defaults,
  -- so this keeps normal mappings while preventing plugin terminal mappings.
  local opts = { silent = true, remap = true }
  vim.keymap.set('n', '<C-W>+', '<Plug>ResizeIncreaseHeight', opts)
  vim.keymap.set('n', '<C-W><kPlus>', '<Plug>ResizeIncreaseHeight', opts)
  vim.keymap.set('n', '<C-W>-', '<Plug>ResizeDecreaseHeight', opts)
  vim.keymap.set('n', '<C-W><kMinus>', '<Plug>ResizeDecreaseHeight', opts)
  vim.keymap.set('n', '<C-W>>', '<Plug>ResizeIncreaseWidth', opts)
  vim.keymap.set('n', '<C-W><', '<Plug>ResizeDecreaseWidth', opts)
end

return M
