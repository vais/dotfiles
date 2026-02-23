local M = {}

local function configure_dbui_buffer()
  -- Allow resizing DBUI window width.
  vim.opt_local.winfixwidth = false

  -- Allow resizing DBUI window height.
  vim.opt_local.winfixheight = false

  -- Reuse Ctrl-p + o behavior from classic Vim DBUI mapping.
  vim.keymap.set('n', 'x', '<C-p>o', { buffer = true, silent = true, remap = true })

  -- Remove Ctrl-j mapping in DBUI buffer.
  pcall(vim.keymap.del, 'n', '<C-j>', { buffer = 0 })

  -- Remove Ctrl-k mapping in DBUI buffer.
  pcall(vim.keymap.del, 'n', '<C-k>', { buffer = 0 })
end

local function configure_dbout_buffer()
  -- Allow resizing DB output window width.
  vim.opt_local.winfixwidth = false

  -- Allow resizing DB output window height.
  vim.opt_local.winfixheight = false
end

function M.setup()
  -- Hide the built-in help panel in DBUI.
  vim.g.db_ui_show_help = 0

  -- Enable automatic helper execution for table actions.
  vim.g.db_ui_auto_execute_table_helpers = 1

  -- Always echo DBUI notifications.
  vim.g.db_ui_force_echo_notifications = 1

  -- Keep DBUI drawer sections aligned with the classic Vim setup.
  vim.g.db_ui_drawer_sections = { 'new_query', 'schemas', 'saved_queries', 'buffers' }

  -- Disable vim-dadbod-completion integration.
  vim.g.vim_dadbod_completion_loaded = 1

  -- Treat mysql comments as '-- ...' for tcomment.
  pcall(vim.fn['tcomment#type#Define'], 'mysql', '-- %s')

  -- Treat plsql comments as '-- ...' for tcomment.
  pcall(vim.fn['tcomment#type#Define'], 'plsql', '-- %s')

  -- Add MySQL helper to show CREATE TABLE statement.
  vim.g.db_ui_table_helpers = {
    mysql = {
      ['Show Create Table'] = 'SHOW CREATE TABLE {optional_schema}`{table}`',
    },
  }

  -- Open DBUI drawer.
  vim.keymap.set('n', '<Leader>do', '<Cmd>DBUI<CR>', { silent = true })

  -- Close DBUI drawer.
  vim.keymap.set('n', '<Leader>dq', '<Cmd>DBUIClose<CR>', { silent = true })

  -- Focus DBUI entry for current buffer.
  vim.keymap.set('n', '<Leader>df', '<Cmd>DBUIFindBuffer<CR>', { silent = true })

  local group = vim.api.nvim_create_augroup('ConfigureDadbodUiPlugin', { clear = true })

  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = 'dbui',
    callback = configure_dbui_buffer,
  })

  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = 'dbout',
    callback = configure_dbout_buffer,
  })
end

return M
