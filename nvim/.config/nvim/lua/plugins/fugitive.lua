local M = {}

local function warn_fugitive_buffer()
  if vim.b.fugitive_type == 'index' then
    return
  end

  if vim.b.fugitive_warning_statusline == 1 then
    return
  end

  vim.b.fugitive_warning_statusline = 1

  vim.opt_local.statusline = '%#ErrorMsg#[FUGITIVE]%*' .. vim.o.statusline

  vim.opt_local.modifiable = false
end

local function mark_fugitive_index_replaceable()
  if vim.b.fugitive_type ~= 'index' then
    return
  end

  -- Allow openers that skip special buftypes to reuse Fugitive status windows.
  vim.opt_local.buftype = ''
end

local function git_status_in_new_tab()
  vim.cmd('-tabnew')

  local newbuf = vim.api.nvim_get_current_buf()

  vim.cmd('Ge:')

  if vim.api.nvim_get_current_buf() ~= newbuf then
    pcall(vim.api.nvim_buf_delete, newbuf, { force = true })
  end
end

local function set_diff_context(delta)
  local context = vim.b.git_diff_opts_context or 3
  context = math.max(context + delta, 3)

  vim.b.git_diff_opts_context = context

  vim.env.GIT_DIFF_OPTS = '--unified=' .. context

  vim.cmd('edit')

  vim.env.GIT_DIFF_OPTS = ''
end

local function fugitive_gf_cmd(mode)
  local sid = nil
  for _, info in ipairs(vim.fn.getscriptinfo()) do
    local name = info.name or ''
    if name:find('/vim%-fugitive/autoload/fugitive%.vim', 1, false) then
      sid = info.sid
      break
    end
  end

  if not sid then
    return nil
  end

  local ok, cmd = pcall(vim.fn[('<SNR>%d_GF'):format(sid)], mode)
  if not ok or type(cmd) ~= 'string' or cmd == '' then
    return nil
  end

  return cmd
end

local function apply_fugitive_status_open_mapping()
  if vim.b.fugitive_type ~= 'index' then
    return
  end

  local function open_in_sibling_or_vsplit(keep_focus)
    local cmd = fugitive_gf_cmd('edit')
    if not cmd then
      return
    end

    local status_win = vim.api.nvim_get_current_win()
    local wins = vim.api.nvim_tabpage_list_wins(0)
    local target = nil

    if #wins > 1 then
      local alt_nr = vim.fn.winnr('#')
      if alt_nr > 0 then
        local alt_id = vim.fn.win_getid(alt_nr)
        if alt_id ~= 0 and alt_id ~= status_win then
          for _, win in ipairs(wins) do
            if win == alt_id then
              target = alt_id
              break
            end
          end
        end
      end

      if not target then
        for _, win in ipairs(wins) do
          if win ~= status_win then
            target = win
            break
          end
        end
      end
    end

    if target then
      vim.api.nvim_set_current_win(target)
    else
      vim.cmd('rightbelow vsplit')
    end

    vim.cmd(cmd)
    pcall(vim.cmd, 'normal! zz')

    if keep_focus and vim.api.nvim_win_is_valid(status_win) then
      vim.api.nvim_set_current_win(status_win)
    end
  end

  vim.keymap.set('n', 'o', function()
    open_in_sibling_or_vsplit(false)
  end, { buffer = true, silent = true })

  vim.keymap.set('n', '<2-LeftMouse>', function()
    open_in_sibling_or_vsplit(false)
  end, { buffer = true, silent = true })

  vim.keymap.set('n', 'go', function()
    open_in_sibling_or_vsplit(true)
  end, { buffer = true, silent = true })

  local function open_fugitive_mode(mode)
    local cmd = fugitive_gf_cmd(mode)
    if not cmd then
      return
    end
    vim.cmd(cmd)
    pcall(vim.cmd, 'normal! zz')
  end

  vim.keymap.set('n', '<CR>', function()
    open_fugitive_mode('edit')
  end, { buffer = true, silent = true })

  vim.keymap.set('n', 'gO', function()
    open_fugitive_mode('vsplit')
  end, { buffer = true, silent = true })

  vim.keymap.set('n', 'O', function()
    open_fugitive_mode('tabedit')
  end, { buffer = true, silent = true })
end

local function configure_fugitive_buffer()
  mark_fugitive_index_replaceable()

  -- Remove Fugitive's default mapping for staging/resetting and repurpose keys.
  pcall(vim.keymap.del, 'n', 'a', { buffer = 0 })

  -- Use '-' to stage/reset the current item.
  vim.keymap.set('n', '-', '=', { buffer = true, silent = true, remap = true })

  -- Jump between files/hunks in Fugitive status buffers.
  vim.keymap.set('n', '<C-n>', ']m>', { buffer = true, silent = true, remap = true })

  vim.keymap.set('n', '<C-p>', '[m>', { buffer = true, silent = true, remap = true })

  -- Stage/reset current entry, then expand inline diff for it.
  vim.keymap.set('n', '<C-s>', 's>', { buffer = true, silent = true, remap = true })

  -- Close Fugitive status buffer and return to previous buffer in this window.
  vim.keymap.set('n', 'q', '<C-w>c', { buffer = true, silent = true, remap = true })

  -- Increase inline diff context and reload.
  vim.keymap.set('n', '<C-a>', function()
    set_diff_context(1)
  end, { buffer = true, silent = true })

  -- Decrease inline diff context and reload.
  vim.keymap.set('n', '<C-x>', function()
    set_diff_context(-1)
  end, { buffer = true, silent = true })

  -- Reload fugitive status, redraw, and clear inline diffs.
  vim.keymap.set('n', '<Leader>l', ':call fugitive#ReloadStatus()<Bar>redraw!<CR>gg<', { buffer = true, silent = true, remap = true })

  apply_fugitive_status_open_mapping()

  local group = vim.api.nvim_create_augroup('FugitiveAutoReloadStatus', { clear = false })

  -- Keep Fugitive status fresh when re-entering the buffer without recursive reload loops.
  vim.api.nvim_clear_autocmds({ group = group, buffer = 0, event = 'BufEnter' })

  vim.api.nvim_create_autocmd('BufEnter', {
    group = group,
    buffer = 0,
    callback = function()
      if vim.g.fugitive_reload_after_toggleterm ~= true then
        return
      end

      vim.g.fugitive_reload_after_toggleterm = false

      if vim.b.fugitive_auto_reload_running then
        return
      end

      vim.b.fugitive_auto_reload_running = true

      local ok = pcall(vim.fn['fugitive#ReloadStatus'])

      vim.b.fugitive_auto_reload_running = false

      if not ok then
        return
      end

      apply_fugitive_status_open_mapping()
    end,
  })
end

local function configure_fugitive_blame_buffer()
  -- Close fugitive blame view with q.
  vim.keymap.set('n', 'q', 'gq', { buffer = true, silent = true, remap = true })
end

local function configure_git_buffer()
  -- Start with folds closed in git buffers.
  vim.opt_local.foldlevel = 0

  -- Build folds from syntax regions.
  vim.opt_local.foldmethod = 'syntax'

  -- Use the default fold text formatter.
  vim.opt_local.foldtext = 'foldtext()'

  -- Toggle fold under cursor.
  vim.keymap.set('n', '-', 'za', { buffer = true, silent = true, remap = true })

  -- Toggle fold under cursor without waiting for further key sequence.
  vim.keymap.set('n', '=', 'za', { buffer = true, silent = true, remap = true, nowait = true })

  -- Move to next hunk and open it.
  vim.keymap.set('n', '<C-n>', 'zm]mza', { buffer = true, silent = true, remap = true })

  -- Move to previous hunk and open it.
  vim.keymap.set('n', '<C-p>', 'zm[mza', { buffer = true, silent = true, remap = true })

  -- Increase inline diff context and reopen around cursor.
  vim.keymap.set('n', '<C-a>', function()
    set_diff_context(1)

    vim.cmd('normal! zv')
  end, { buffer = true, silent = true })

  -- Decrease inline diff context and reopen around cursor.
  vim.keymap.set('n', '<C-x>', function()
    set_diff_context(-1)

    vim.cmd('normal! zv')
  end, { buffer = true, silent = true })
end

function M.setup()
  local configure_fugitive_group = vim.api.nvim_create_augroup('ConfigureFugitivePlugin', { clear = true })

  vim.api.nvim_create_autocmd('User', {
    group = configure_fugitive_group,
    pattern = 'FugitiveIndex',
    callback = function()
      vim.opt_local.bufhidden = 'hide'
      mark_fugitive_index_replaceable()
    end,
  })

  local warning_statusline_group = vim.api.nvim_create_augroup('FugitiveWarningStatusline', { clear = true })

  vim.api.nvim_create_autocmd('BufWinEnter', {
    group = warning_statusline_group,
    pattern = 'fugitive://*',
    callback = warn_fugitive_buffer,
  })

  vim.api.nvim_create_autocmd('FileType', {
    group = configure_fugitive_group,
    pattern = 'fugitive',
    callback = configure_fugitive_buffer,
  })

  vim.api.nvim_create_autocmd('FileType', {
    group = configure_fugitive_group,
    pattern = 'fugitiveblame',
    callback = configure_fugitive_blame_buffer,
  })

  vim.api.nvim_create_autocmd('FileType', {
    group = configure_fugitive_group,
    pattern = 'git',
    callback = configure_git_buffer,
  })

  -- Open git blame for the current file.
  vim.keymap.set('n', '<Leader>gb', '<Cmd>Git blame<CR>', { silent = true })

  -- Open commit history with GV.
  vim.keymap.set('n', '<Leader>gv', '<Cmd>GV -99<CR>', { silent = true })

  -- Open current file through Fugitive.
  vim.keymap.set('n', '<Leader>ge', '<Cmd>Gedit<CR>', { silent = true })

  -- Open Fugitive status in a new tab.
  vim.keymap.set('n', '<Leader>gg', git_status_in_new_tab, { silent = true })

  -- Open Fugitive status in a left vertical split.
  vim.keymap.set('n', '<Leader>gh', '<Cmd>wincmd v | wincmd h | Ge:<CR>', { silent = true })

  -- Open Fugitive status in a far-left vertical split.
  vim.keymap.set('n', '<Leader>gH', '<Cmd>topleft wincmd v | Ge:<CR>', { silent = true })

  -- Open Fugitive status in a horizontal split below.
  vim.keymap.set('n', '<Leader>gj', '<Cmd>wincmd s | Ge:<CR>', { silent = true })

  -- Open Fugitive status in a bottom horizontal split.
  vim.keymap.set('n', '<Leader>gJ', '<Cmd>botright wincmd s | Ge:<CR>', { silent = true })

  -- Open Fugitive status in a horizontal split above.
  vim.keymap.set('n', '<Leader>gk', '<Cmd>wincmd s | wincmd k | Ge:<CR>', { silent = true })

  -- Open Fugitive status in a top horizontal split.
  vim.keymap.set('n', '<Leader>gK', '<Cmd>topleft wincmd s | Ge:<CR>', { silent = true })

  -- Open Fugitive status in a vertical split on the right.
  vim.keymap.set('n', '<Leader>gl', '<Cmd>wincmd v | Ge:<CR>', { silent = true })

  -- Open Fugitive status in a far-right vertical split.
  vim.keymap.set('n', '<Leader>gL', '<Cmd>botright wincmd v | Ge:<CR>', { silent = true })

  -- Open Fugitive status in the current window.
  vim.keymap.set('n', '<Leader>g.', '<Cmd>Ge:<CR>', { silent = true })
end

return M
