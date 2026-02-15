local M = {}

function M.setup()
  -- Use floating hunk previews with explicit Neovim window options.
  vim.g.gitgutter_preview_win_floating = 1
  vim.g.gitgutter_floating_window_options = {
    relative = 'cursor',
    row = 1,
    col = 0,
    width = 72,
    height = vim.o.previewheight,
    style = 'minimal',
    border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
  }

  -- Preview the hunk under cursor.
  vim.keymap.set('n', '<Leader>hp', '<Plug>(GitGutterPreviewHunk)', { remap = true })

  -- Stage the hunk under cursor.
  vim.keymap.set('n', '<Leader>hs', '<Plug>(GitGutterStageHunk)', { remap = true })

  -- Undo the staged hunk under cursor.
  vim.keymap.set('n', '<Leader>hu', '<Plug>(GitGutterUndoHunk)', { remap = true })

  -- Populate quickfix with hunks and open it.
  vim.keymap.set('n', '<Leader>hc', '<Cmd>GitGutterQuickFix | botright copen<CR>', { silent = true })

  -- Toggle line-level GitGutter highlights.
  vim.keymap.set('n', '<Leader>hl', '<Cmd>GitGutterLineHighlightsToggle<CR>', { silent = true })

  -- Toggle GitGutter signs.
  vim.keymap.set('n', '<Leader>ht', '<Cmd>GitGutterToggle<CR>', { silent = true })

  -- Fold unchanged lines using GitGutter hunks.
  vim.keymap.set('n', '<Leader>hz', '<Cmd>GitGutterFold<CR>', { silent = true })
end

return M
