-- Remove Fugitive's default mapping for staging/resetting and repurpose keys.
pcall(vim.keymap.del, 'n', 'a', { buffer = 0 })

-- Use '-' to stage/reset the current item.
vim.keymap.set('n', '-', '=', { buffer = true, silent = true, remap = true })

-- Jump between files/hunks in Fugitive status buffers.
vim.keymap.set('n', '<C-n>', ']m>', { buffer = true, silent = true, remap = true })

vim.keymap.set('n', '<C-p>', '[m>', { buffer = true, silent = true, remap = true })

-- Open split diff for the current entry.
vim.keymap.set('n', '<C-s>', 's>', { buffer = true, silent = true, remap = true })

-- Close Fugitive status buffer and return to previous buffer in this window.
vim.keymap.set('n', 'q', '<C-w>c', { buffer = true, silent = true, remap = true })

local function set_diff_context(delta)
  local context = vim.b.git_diff_opts_context or 3
  context = math.max(context + delta, 3)

  vim.b.git_diff_opts_context = context

  vim.env.GIT_DIFF_OPTS = '--unified=' .. context

  vim.cmd('edit')

  vim.env.GIT_DIFF_OPTS = ''
end

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

local function apply_status_open_mapping()
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
    pcall(vim.cmd, "normal! zz")

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
    pcall(vim.cmd, "normal! zz")
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

apply_status_open_mapping()

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

    apply_status_open_mapping()
  end,
})
