local M = {}

function M.setup()
  -- Build CtrlP file list from git-tracked and untracked files.
  vim.g.ctrlp_user_command = { '.git', 'git ls-files -co --exclude-standard' }

  -- Keep search rooted where it was invoked.
  vim.g.ctrlp_working_path_mode = 0

  -- Keep CtrlP cache between sessions.
  vim.g.ctrlp_clear_cache_on_exit = 0

  -- Let CtrlP use nearly full-height list.
  vim.g.ctrlp_max_height = 999

  -- Show relative-ish buffer names in CtrlP buffer mode.
  vim.g.ctrlp_bufname_mod = ':.'

  -- Do not prepend extra path modifier in CtrlP buffer mode.
  vim.g.ctrlp_bufpath_mod = ''

  -- Prioritize current file in results.
  vim.g.ctrlp_match_current_file = 1

  -- Reuse current window when opening selected buffer.
  vim.g.ctrlp_switch_buffer = 'e'


  -- Disable CtrlP default keymap (for example, Ctrl-p).
  vim.g.ctrlp_map = ''

  -- Open CtrlP file list with Leader+p.
  vim.keymap.set('n', '<Leader>p', '<Cmd>CtrlP<CR>', { silent = true })

  -- Open CtrlP file list with Leader+p from visual mode.
  vim.keymap.set('x', '<Leader>p', '<Cmd>CtrlP<CR>', { silent = true })

  -- Open CtrlP buffer list with Leader+o.
  vim.keymap.set('n', '<Leader>o', '<Cmd>CtrlPBuffer<CR>', { silent = true })

  -- Open CtrlP buffer list with Leader+o from visual mode.
  vim.keymap.set('x', '<Leader>o', '<Cmd>CtrlPBuffer<CR>', { silent = true })
end

return M
