local M = {}

local function get_visual_selection()
  local mode = vim.fn.mode()
  local in_visual = mode == 'v' or mode == 'V' or mode == '\22'

  local start_pos
  local end_pos
  local selection_type

  if in_visual then
    start_pos = vim.fn.getpos('v')
    end_pos = vim.fn.getpos('.')
    selection_type = mode
  else
    start_pos = vim.fn.getpos("'<")
    end_pos = vim.fn.getpos("'>")
    selection_type = vim.fn.visualmode()
  end

  if start_pos[2] == 0 or end_pos[2] == 0 then
    return ''
  end

  local region = vim.fn.getregion(start_pos, end_pos, { type = selection_type })
  if type(region) ~= 'table' or #region == 0 then
    return ''
  end

  return table.concat(region, '\n')
end

local function apply_search_pattern(pattern)
  vim.fn.setreg('/', pattern)
  vim.fn.histadd('search', pattern)
end

local function exit_visual_mode()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'nx', false)
end

local function configure_grep_for_find_in_files()
  -- Read grep patterns from ~/.vimsearch, one per line.
  local pattern_file = vim.fn.expand('~/.vimsearch')
  vim.opt.grepprg = 'git grep -f "' .. pattern_file .. '" -I -n'

  -- Parse grep output with or without an explicit column number.
  vim.opt.grepformat = '%f:%l:%c:%m,%f:%l:%m'
end

function M.set_search_term_normal()
  local str = vim.fn.expand('<cword>')

  if str == nil or str == '' then
    vim.api.nvim_echo({ { 'E348: No string under cursor', 'ErrorMsg' } }, false, {})
    return ''
  end

  apply_search_pattern([[\V\<]] .. str .. [[\>\C]])
  return str
end

function M.set_search_term_visual()
  local str = get_visual_selection()

  local escaped = vim.fn.escape(str, [[\]])
  local pattern = [[\V]] .. vim.fn.substitute(escaped, '\n', [[\\n]], 'g')
  apply_search_pattern(pattern)

  return str
end

function M.find_in_files(text, whole_word)
  local txt = text or ''
  local grep_args = '-Fi'

  if whole_word then
    if txt == '' then
      return
    end

    txt = [[\b]] .. txt .. [[\b]]
    grep_args = '-P'
  end

  local prompt = 'Search ' .. vim.fn.getcwd() .. '>'
  local str = vim.fn.input(prompt, txt)

  if str == '' then
    vim.schedule(function()
      vim.api.nvim_echo({ { '' } }, false, {})
    end)
    return
  end

  vim.fn.writefile({ str }, vim.fn.expand('~/.vimsearch'))
  local cmdline = vim.api.nvim_replace_termcodes(
    ':<C-u>botright copen | silent grep! ' .. grep_args,
    true,
    false,
    true
  )
  vim.fn.feedkeys(cmdline, 'n')
end

function M.setup()
  configure_grep_for_find_in_files()

  -- Set current word or visual selection as the current search term.
  vim.keymap.set('n', 'gn', function()
    M.set_search_term_normal()
  end, { silent = true })

  vim.keymap.set('x', 'gn', function()
    M.set_search_term_visual()
    exit_visual_mode()
  end, { silent = true })

  -- Find in files.
  vim.keymap.set('n', '<F3>', function()
    M.find_in_files('')
  end, { silent = true })

  vim.keymap.set('n', '<S-F3>', function()
    M.find_in_files(M.set_search_term_normal(), true)
  end, { silent = true })

  vim.keymap.set('x', '<F3>', function()
    M.find_in_files(M.set_search_term_visual())
  end, { silent = true })

  vim.keymap.set('x', '<S-F3>', function()
    M.find_in_files(M.set_search_term_visual(), true)
  end, { silent = true })
end

return M
