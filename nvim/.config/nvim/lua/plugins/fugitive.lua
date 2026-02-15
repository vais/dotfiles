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

local function git_status_in_new_tab()
  vim.cmd('-tabnew')

  local newbuf = vim.api.nvim_get_current_buf()

  vim.cmd('Ge:')

  if vim.api.nvim_get_current_buf() ~= newbuf then
    pcall(vim.api.nvim_buf_delete, newbuf, { force = true })
  end
end

function M.setup()
  local configure_fugitive_group = vim.api.nvim_create_augroup('ConfigureFugitivePlugin', { clear = true })

  vim.api.nvim_create_autocmd('User', {
    group = configure_fugitive_group,
    pattern = 'FugitiveIndex',
    callback = function()
      vim.opt_local.bufhidden = 'hide'
    end,
  })

  local warning_statusline_group = vim.api.nvim_create_augroup('FugitiveWarningStatusline', { clear = true })

  vim.api.nvim_create_autocmd('BufWinEnter', {
    group = warning_statusline_group,
    pattern = 'fugitive://*',
    callback = warn_fugitive_buffer,
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
