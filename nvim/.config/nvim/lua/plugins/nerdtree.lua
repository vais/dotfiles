local M = {}

local function configure_nerdtree_buffer()
  -- Allow resizing NERDTree windows freely.
  vim.opt_local.winfixwidth = false

  -- Allow resizing NERDTree window height freely.
  vim.opt_local.winfixheight = false

  -- Unmap Ctrl-j in NERDTree buffer.
  pcall(vim.keymap.del, 'n', '<C-j>', { buffer = 0 })

  -- Unmap Ctrl-k in NERDTree buffer.
  pcall(vim.keymap.del, 'n', '<C-k>', { buffer = 0 })
end

function M.setup()
  -- Keep NERDTree open for normal open actions.
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

  -- "<CR>" uses these custom args.
  vim.g.NERDTreeMapCustomOpen = '<CR>'
  vim.g.NERDTreeCustomOpenArgs = {
    -- Open in prior window and close the tree.
    file = { reuse = 'currenttab', where = 'p', keepopen = 0, stay = 0 },
    dir = {},
  }

  -- Keep "o" from jumping to other tabs when the file is already open.
  vim.cmd([[
    function! NERDTreeActivateFileNodeCurrentTab(node) abort
      call a:node.activate({'reuse': 'currenttab', 'where': 'p', 'keepopen': !nerdtree#closeTreeOnOpen()})
    endfunction
  ]])

  local group = vim.api.nvim_create_augroup('ConfigureNerdTreePlugin', { clear = true })

  vim.api.nvim_create_autocmd('User', {
    group = group,
    pattern = 'NERDTreeInit',
    callback = function()
      vim.fn.NERDTreeAddKeyMap({
        key = 'o',
        scope = 'FileNode',
        callback = 'NERDTreeActivateFileNodeCurrentTab',
        quickhelpText = 'open in prev window',
        override = 1,
      })
    end,
  })

  -- Focus NERDTree window.
  vim.keymap.set('n', '<Leader>fo', '<Cmd>NERDTreeFocus<CR>', { silent = true })

  -- Close NERDTree window.
  vim.keymap.set('n', '<Leader>fq', '<Cmd>NERDTreeClose<CR>', { silent = true })

  -- Reveal current file in NERDTree.
  vim.keymap.set('n', '<Leader>ff', '<Cmd>NERDTreeFind<CR>', { silent = true })

  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = 'nerdtree',
    callback = configure_nerdtree_buffer,
  })
end

return M
