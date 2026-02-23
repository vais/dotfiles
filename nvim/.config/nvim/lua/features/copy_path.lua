local M = {}

local function exit_visual_mode()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'nx', false)
end

local function get_copy_path(kind)
  local file = vim.api.nvim_buf_get_name(0)
  if file == nil or file == '' then
    vim.api.nvim_err_writeln('No file path available for this buffer')
    return ''
  end

  if kind == 'absolute' then
    return file
  end

  -- Default to a path relative to the working directory.
  return vim.fn.fnamemodify(file, ':.')
end

local function get_visual_line_range()
  local start_line = vim.fn.line('v')
  local end_line = vim.fn.line('.')

  if start_line == 0 or end_line == 0 then
    start_line = vim.fn.line("'<")
    end_line = vim.fn.line("'>")
  end

  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  return start_line, end_line
end

function M.copy_file_path(kind, start_line, end_line)
  local path = get_copy_path(kind)
  if path == '' then
    return
  end

  local start = start_line or 0
  local ending = end_line or 0

  if start > 0 then
    ending = ending > 0 and ending or start
    if start > ending then
      start, ending = ending, start
    end

    if start == ending then
      path = path .. ':' .. start
    else
      path = path .. ':' .. start .. '-' .. ending
    end
  end

  vim.fn.setreg('+', path, 'v')
  vim.api.nvim_echo({ { 'Copied: ' .. path } }, false, {})
end

function M.copy_visual_file_path(kind)
  local start_line, end_line = get_visual_line_range()
  M.copy_file_path(kind, start_line, end_line)
end

function M.setup()
  -- Copy current buffer path to the system clipboard.
  vim.keymap.set('n', '<Leader>fa', function()
    M.copy_file_path('absolute', 0, 0)
  end, { silent = true })

  vim.keymap.set('n', '<Leader>fr', function()
    M.copy_file_path('relative', 0, 0)
  end, { silent = true })

  vim.keymap.set('n', '<Leader>fl', function()
    local line = vim.fn.line('.')
    M.copy_file_path('relative', line, line)
  end, { silent = true })

  vim.keymap.set('x', '<Leader>fa', function()
    M.copy_visual_file_path('absolute')
    exit_visual_mode()
  end, { silent = true })

  vim.keymap.set('x', '<Leader>fr', function()
    M.copy_visual_file_path('relative')
    exit_visual_mode()
  end, { silent = true })

  vim.keymap.set('x', '<Leader>fl', function()
    M.copy_visual_file_path('relative')
    exit_visual_mode()
  end, { silent = true })
end

return M
