local M = {}

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
end

return M
