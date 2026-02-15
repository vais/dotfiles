local M = {}

function M.setup()
  -- Keep NERDTree open for normal open actions (for "o" and mouse activation).
  vim.g.NERDTreeQuitOnOpen = 0

  -- Use minimal menu entries.
  vim.g.NERDTreeMinimalMenu = 1

  -- Use minimal UI in the tree buffer.
  vim.g.NERDTreeMinimalUI = 1

  -- Highlight cursorline in NERDTree.
  vim.g.NERDTreeHighlightCursorline = 1

  -- Show hidden files.
  vim.g.NERDTreeShowHidden = 1

  -- Do not hijack netrw behavior globally.
  vim.g.NERDTreeHijackNetrw = 0

  -- Use a middle-dot delimiter between node name and metadata.
  vim.g.NERDTreeNodeDelimiter = '·'

  -- "<CR>" uses these args (NERDTreeMapCustomOpen), while "o" keeps default behavior.
  vim.g.NERDTreeMapCustomOpen = '<CR>'
  vim.g.NERDTreeCustomOpenArgs = {
    -- Open in prior window and close the tree.
    file = { reuse = 'currenttab', where = 'p', keepopen = 0, stay = 0 },
    dir = {},
  }

  -- Focus NERDTree window.
  vim.keymap.set('n', '<Leader>fo', '<Cmd>NERDTreeFocus<CR>', { silent = true })

  -- Close NERDTree window.
  vim.keymap.set('n', '<Leader>fq', '<Cmd>NERDTreeClose<CR>', { silent = true })

  -- Reveal current file in NERDTree.
  vim.keymap.set('n', '<Leader>ff', '<Cmd>NERDTreeFind<CR>', { silent = true })
end

return M
