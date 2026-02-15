local M = {}

function M.setup()
  -- Disable default mappings and use explicit custom mappings.
  vim.g.textobj_entire_no_default_key_mappings = 1

  -- Select the entire buffer as "around" text object in visual mode.
  vim.keymap.set('x', 'ag', '<Plug>(textobj-entire-a)', { remap = true })

  -- Select the entire buffer as "around" text object in operator-pending mode.
  vim.keymap.set('o', 'ag', '<Plug>(textobj-entire-a)', { remap = true })

  -- Select the entire buffer as "inner" text object in visual mode.
  vim.keymap.set('x', 'ig', '<Plug>(textobj-entire-i)', { remap = true })

  -- Select the entire buffer as "inner" text object in operator-pending mode.
  vim.keymap.set('o', 'ig', '<Plug>(textobj-entire-i)', { remap = true })
end

return M
