local M = {}

local function ale_is_checking_current_buffer()
  if vim.fn.exists('*ale#engine#IsCheckingBuffer') == 0 then
    return false
  end

  return vim.fn['ale#engine#IsCheckingBuffer'](vim.fn.bufnr('')) == 1
end

_G.ALEProgress = function()
  if ale_is_checking_current_buffer() then
    return '[lint...]'
  end

  return ''
end

_G.ALEStatus = function()
  if ale_is_checking_current_buffer() then
    return ''
  end

  local counts = vim.fn['ale#statusline#Count'](vim.fn.bufnr(''))
  local issues = counts.total or 0

  if issues == 0 then
    return ''
  end

  if issues == 1 then
    return '[1 issue]'
  end

  return string.format('[%d issues]', issues)
end

local function append_statusline_once(segment)
  local current = vim.o.statusline
  if string.find(current, segment, 1, true) then
    return
  end

  vim.opt.statusline:append(segment)
end

function M.setup()
  -- Use ALE's native UI instead of Neovim diagnostics API for Vim-like behavior.
  vim.g.ale_use_neovim_diagnostics_api = 0

  -- Keep ALE's global floating preview mode disabled, but show hover in floats.
  vim.g.ale_floating_preview = 0
  vim.g.ale_hover_to_floating_preview = 1
  vim.g.ale_detail_to_floating_preview = 0
  vim.g.ale_floating_window_border = { '│', '─', '╭', '╮', '╯', '╰', '│', '─' }

  -- Fix files on save with configured fixers.
  vim.g.ale_fix_on_save = 1

  -- Use language-specific fixers.
  vim.g.ale_fixers = {
    javascript = { 'eslint' },
    typescript = { 'prettier' },
    typescriptreact = { 'prettier' },
    html = { 'prettier' },
    css = { 'prettier' },
  }

  -- Run linting on save.
  vim.g.ale_lint_on_save = 1

  -- Only run explicitly listed linters.
  vim.g.ale_linters_explicit = 1

  -- Use language-specific linters.
  vim.g.ale_linters = {
    javascript = { 'eslint', 'tsserver' },
    typescript = { 'eslint', 'tsserver' },
    typescriptreact = { 'eslint', 'tsserver' },
    ruby = { 'ruby' },
  }

  -- Keep local eslint override flags used in Vim config.
  vim.g.ale_javascript_eslint_options = "--rule 'no-debugger: off, import/no-unused-modules: off'"

  -- Do not lint on enter/filetype change/insert leave/text changed.
  vim.g.ale_lint_on_enter = 0
  vim.g.ale_lint_on_filetype_changed = 0
  vim.g.ale_lint_on_insert_leave = 0
  vim.g.ale_lint_on_text_changed = 0

  -- Disable ALE-provided highlights and balloons.
  vim.g.ale_set_highlights = 0
  vim.g.ale_set_balloons = 0

  -- Do not auto-hover under cursor.
  vim.g.ale_hover_cursor = 0

  -- Show hover for symbol under cursor.
  vim.keymap.set('n', 'K', '<Cmd>ALEHover<CR>', { silent = true })

  -- Show documentation for symbol under cursor.
  vim.keymap.set('n', '<F1>', '<Cmd>ALEDocumentation<CR>', { silent = true })

  -- Go to definition in current window.
  vim.keymap.set('n', 'gd', '<Cmd>ALEGoToDefinition<CR>', { silent = true })

  -- Go to definition in a vertical split.
  vim.keymap.set('n', '<C-w>d', '<Cmd>ALEGoToDefinition -vsplit<CR>', { silent = true })

  -- Go to definition in a horizontal split.
  vim.keymap.set('n', '<C-w>D', '<Cmd>ALEGoToDefinition -split<CR>', { silent = true })
  vim.keymap.set('n', '<C-w><C-d>', '<Cmd>ALEGoToDefinition -split<CR>', { silent = true })

  -- Go to definition in a new tab.
  vim.keymap.set('n', '<C-w>gd', '<Cmd>ALEGoToDefinition -tab<CR>', { silent = true })

  -- Navigate ALE problems.
  vim.keymap.set('n', '[E', '<Cmd>ALEFirst<CR>', { silent = true })
  vim.keymap.set('n', '[e', '<Cmd>ALEPrevious<CR>', { silent = true })
  vim.keymap.set('n', ']e', '<Cmd>ALENext<CR>', { silent = true })
  vim.keymap.set('n', ']E', '<Cmd>ALELast<CR>', { silent = true })

  -- Trigger ALE completion unless popup menu is visible.
  vim.keymap.set('i', '<C-@>', function()
    if vim.fn.pumvisible() == 1 then
      return '<C-n>'
    end

    return '<Plug>(ale_complete)'
  end, { expr = true, remap = true })

  vim.keymap.set('i', '<C-Space>', function()
    if vim.fn.pumvisible() == 1 then
      return '<C-n>'
    end

    return '<Plug>(ale_complete)'
  end, { expr = true, remap = true })

  -- Use popup menu navigation for insert Ctrl-j/Ctrl-k when completion menu is open.
  vim.keymap.set('i', '<C-j>', function()
    if vim.fn.pumvisible() == 1 then
      return '<C-n>'
    end

    return '<C-j>'
  end, { expr = true })

  vim.keymap.set('i', '<C-k>', function()
    if vim.fn.pumvisible() == 1 then
      return '<C-p>'
    end

    return '<C-k>'
  end, { expr = true })

  -- Add ALE progress and issue count to statusline.
  append_statusline_once('%{v:lua.ALEProgress()}')
  append_statusline_once('%#ErrorMsg#%{v:lua.ALEStatus()}%*')

  local group = vim.api.nvim_create_augroup('ConfigureAlePlugin', { clear = true })

  -- Keep statusline current when ALE starts and finishes work.
  vim.api.nvim_create_autocmd('User', {
    group = group,
    pattern = 'ALEJobStarted',
    command = 'redrawstatus!',
  })

  vim.api.nvim_create_autocmd('User', {
    group = group,
    pattern = 'ALELintPost',
    command = 'redrawstatus!',
  })
end

return M
