local M = {}

function M.setup(formatter_lang)
  -- Use vim-dadbod completion for SQL omni completion.
  vim.opt_local.omnifunc = 'vim_dadbod_completion#omni'

  local function omni_complete_or_next_item()
    if vim.fn.pumvisible() == 1 then
      return '<C-n>'
    end

    return '<C-x><C-o>'
  end

  -- Complete to next item when menu is visible, otherwise start omni completion.
  vim.keymap.set('i', '<C-@>', omni_complete_or_next_item, { buffer = true, expr = true, silent = true })

  -- Match Ctrl-Space keycode variants for omni completion.
  vim.keymap.set('i', '<C-Space>', omni_complete_or_next_item, { buffer = true, expr = true, silent = true })

  local normal_cmd = string.format('<Cmd>%%!sql-formatter -l %s<CR>', formatter_lang)
  local visual_cmd = string.format(":'<,'>!sql-formatter -l %s<CR>", formatter_lang)

  -- Format entire buffer with sql-formatter.
  vim.keymap.set('n', '<Leader>F', normal_cmd, { buffer = true, silent = true })

  -- Format visual selection with sql-formatter.
  vim.keymap.set('x', '<Leader>F', visual_cmd, { buffer = true, silent = true })
end

return M
