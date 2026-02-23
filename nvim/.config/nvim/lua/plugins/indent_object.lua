local M = {}

local function apply_indent_object_mappings()
  -- Use indent-object's around-same-indent text object for ai.
  vim.keymap.set('o', 'ai', 'aI', { remap = true })
  vim.keymap.set('v', 'ai', 'aI', { remap = true })
end

function M.setup()
  apply_indent_object_mappings()

  -- Re-apply whenever indent-object's plugin script is sourced.
  vim.api.nvim_create_autocmd('SourcePost', {
    group = vim.api.nvim_create_augroup('IndentObjectMappings', { clear = true }),
    pattern = '*/plugin/indent-object.vim',
    callback = apply_indent_object_mappings,
  })
end

return M
