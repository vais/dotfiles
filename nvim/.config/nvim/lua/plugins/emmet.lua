local M = {}

function M.setup()
  -- Do not install Emmet default mappings; use explicit mappings only.
  vim.g.emmet_install_only_plug = 1

  -- Expand Emmet abbreviation in insert mode.
  vim.keymap.set('i', '<C-\\>', '<Plug>(emmet-expand-abbr)', { remap = true })

  -- Expand Emmet abbreviation in visual/select mode.
  vim.keymap.set('v', '<C-\\>', '<Plug>(emmet-expand-abbr)', { remap = true })
end

return M
