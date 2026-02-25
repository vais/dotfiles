local M = {}

local Terminal = require('toggleterm.terminal').Terminal
local term_label = require('features.toggleterm_label')

local assistants = {
  Aider = {
    name = 'aider',
    prompt_pattern = '^[a-z -]*> ',
  },
  Claude = {
    name = 'claude',
    prompt_pattern = '^❯',
  },
  Codex = {
    name = 'codex',
    prompt_pattern = '^› ',
    disable_ctrl_d = true,
  },
  Cursor = {
    name = 'cursor-agent',
    prompt_pattern = '^ │ ',
    disable_ctrl_d = true,
    cursor_image_workaround = true,
  },
}

local state = {
  captured_context = '',
  terms = {},
}

local jump_highlight_ns = vim.api.nvim_create_namespace('ai_term_jump_highlight')
local jump_highlight_augroup = vim.api.nvim_create_augroup('ai_term_jump_highlight', { clear = true })
local jump_highlight_state = {
  buf = nil,
  timer = nil,
}

local function close_jump_highlight_timer()
  local timer = jump_highlight_state.timer
  if not timer then
    return
  end

  timer:stop()

  local is_closing = false
  local ok, result = pcall(function()
    return timer:is_closing()
  end)
  if ok then
    is_closing = result
  end

  if not is_closing then
    timer:close()
  end

  jump_highlight_state.timer = nil
end

local function clear_jump_highlight()
  if jump_highlight_state.timer then
    jump_highlight_state.timer:stop()
  end

  if jump_highlight_state.buf and vim.api.nvim_buf_is_valid(jump_highlight_state.buf) then
    vim.api.nvim_buf_clear_namespace(jump_highlight_state.buf, jump_highlight_ns, 0, -1)
  end

  jump_highlight_state.buf = nil
end

local function flash_jump_line(buf, line)
  clear_jump_highlight()

  if not vim.api.nvim_buf_is_valid(buf) or line < 1 then
    return
  end

  vim.api.nvim_buf_add_highlight(buf, jump_highlight_ns, 'Search', line - 1, 0, -1)
  jump_highlight_state.buf = buf

  if not jump_highlight_state.timer then
    jump_highlight_state.timer = vim.loop.new_timer()
  end

  jump_highlight_state.timer:start(300, 0, vim.schedule_wrap(function()
    clear_jump_highlight()
  end))
end

local function is_prompt_line(buf, line, pattern)
  if not vim.api.nvim_buf_is_valid(buf) or line < 1 then
    return false
  end

  local text = vim.api.nvim_buf_get_lines(buf, line - 1, line, false)[1]
  if type(text) ~= 'string' then
    return false
  end

  return text:match(pattern) ~= nil
end

local function find_prompt_line(buf, current_line, direction, pattern)
  local line_count = vim.api.nvim_buf_line_count(buf)

  local start_line, stop_line, step
  if direction < 0 then
    start_line = current_line - 1
    stop_line = 1
    step = -1
  else
    start_line = current_line + 1
    stop_line = line_count
    step = 1
  end

  for line = start_line, stop_line, step do
    if is_prompt_line(buf, line, pattern) then
      return line
    end
  end

  return nil
end

local function is_file_buffer(buf)
  return buf > 0
      and vim.api.nvim_buf_is_valid(buf)
      and vim.bo[buf].buftype == ''
      and vim.api.nvim_buf_get_name(buf) ~= ''
end

local function display_path(path)
  local cwd = vim.loop.cwd() or vim.fn.getcwd()
  if cwd and cwd ~= '' then
    local prefix = cwd .. '/'
    if path == cwd then
      return '.'
    end
    if path:sub(1, #prefix) == prefix then
      return path:sub(#prefix + 1)
    end
  end

  local home = vim.loop.os_homedir()
  if home and home ~= '' then
    local prefix = home .. '/'
    if path == home then
      return '~'
    end
    if path:sub(1, #prefix) == prefix then
      return '~/' .. path:sub(#prefix + 1)
    end
  end

  return path
end

local function build_context_line(buf, lnum)
  if not is_file_buffer(buf) then
    return ''
  end

  local path = display_path(vim.api.nvim_buf_get_name(buf))
  local line = lnum > 0 and lnum or 1
  return string.format('%s:%d', path, line)
end

local function build_context_range(buf, line1, line2)
  if not is_file_buffer(buf) or line1 <= 0 or line2 <= 0 then
    return ''
  end

  local s = line1
  local e = line2
  if e < s then
    s, e = e, s
  end

  local path = display_path(vim.api.nvim_buf_get_name(buf))
  if s == e then
    return string.format('%s:%d', path, s)
  end
  return string.format('%s:%d-%d', path, s, e)
end

local function set_pending_context(context)
  state.captured_context = context or ''
end

local function capture_context_from_current_buffer(is_range)
  local buf = vim.api.nvim_get_current_buf()
  if not is_file_buffer(buf) then
    return ''
  end

  if is_range then
    local start_lnum = vim.fn.line('v')
    local end_lnum = vim.fn.line('.')
    if start_lnum == 0 or end_lnum == 0 then
      start_lnum = vim.fn.line("'<")
      end_lnum = vim.fn.line("'>")
    end
    return build_context_range(buf, start_lnum, end_lnum)
  end

  return build_context_line(buf, vim.api.nvim_win_get_cursor(0)[1])
end

local function send_raw(job_id, text)
  local ok = pcall(vim.api.nvim_chan_send, job_id, text)
  return ok
end

local function send_with_bracketed_paste(job_id, text)
  return send_raw(job_id, '\27[200~' .. text .. '\27[201~')
end

local function send_text(term, text)
  if not text or text == '' then
    return
  end

  if not send_with_bracketed_paste(term.job_id, text) then
    send_raw(term.job_id, text)
  end
end

local function get_term_state(term)
  local term_state = state.terms[term.id]
  if term_state then
    return term_state
  end

  term_state = {
    cursor_image_workaround = false,
    temp_files = {},
  }
  state.terms[term.id] = term_state
  return term_state
end

local function cleanup_term_temp_files(term_state)
  for _, path in ipairs(term_state.temp_files) do
    pcall(vim.fn.delete, path)
  end
  term_state.temp_files = {}
end

local function send_ctrl_v_to_term(term)
  send_raw(term.job_id, '\22')
end

local function get_clipboard_text()
  local text = vim.fn.getreg('+')
  if text and text ~= '' then
    return text
  end

  text = vim.fn.getreg('*')
  if text and text ~= '' then
    return text
  end

  if vim.fn.executable('pbpaste') == 1 then
    local out = vim.fn.system({ 'pbpaste' })
    if vim.v.shell_error == 0 and out and out ~= '' then
      return out
    end
  end

  return ''
end

local function write_clipboard_image(path)
  if vim.fn.executable('osascript') ~= 1 then
    return false
  end

  local script = {
    'set theImage to the clipboard as «class PNGf»',
    'set outFile to (POSIX file "' .. path:gsub('["\\]', '\\%1') .. '")',
    'set outRef to open for access outFile with write permission',
    'set eof outRef to 0',
    'write theImage to outRef',
    'close access outRef',
  }

  local cmd = { 'osascript' }
  for _, line in ipairs(script) do
    table.insert(cmd, '-e')
    table.insert(cmd, line)
  end

  vim.fn.system(cmd)
  return vim.v.shell_error == 0
end

local function paste_text_or_image(term)
  local term_state = get_term_state(term)
  local text = get_clipboard_text()
  if text ~= '' then
    send_text(term, text)
    return
  end

  if term_state.cursor_image_workaround then
    local path = vim.fn.tempname() .. '.png'
    if write_clipboard_image(path) then
      table.insert(term_state.temp_files, path)
      send_text(term, path)
      return
    end

    vim.fn.delete(path)
  end

  send_ctrl_v_to_term(term)
end

local function jump_to_prompt(buf, direction)
  clear_jump_highlight()

  local pattern = vim.b[buf].ai_prompt_pattern
  if type(pattern) ~= 'string' or pattern == '' then
    return
  end

  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local found = find_prompt_line(buf, current_line, direction, pattern)

  if not found then
    if is_prompt_line(buf, current_line, pattern) then
      flash_jump_line(buf, current_line)
    end
    return
  end

  vim.api.nvim_win_set_cursor(0, { found, 0 })
  flash_jump_line(buf, found)
end

function M.capture_visual_selection()
  set_pending_context(capture_context_from_current_buffer(true))
end

function M.capture_current_location()
  set_pending_context(capture_context_from_current_buffer(false))
end

local function configure_buffer(term, assistant)
  local buf = term.bufnr
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  vim.b[buf].ai_assistant = assistant.name
  vim.b[buf].ai_prompt_pattern = assistant.prompt_pattern or ''
  vim.bo[buf].scrollback = 999

  local opts = { buffer = buf, silent = true }

  -- Keep file-jump mappings from triggering in assistant terminal buffers.
  vim.keymap.set({ 'n', 'x' }, 'gf', '<Nop>', opts)
  vim.keymap.set({ 'n', 'x' }, 'gF', '<Nop>', opts)
  vim.keymap.set({ 'n', 'x' }, '<C-w>f', '<Cmd>vertical wincmd f<CR>', opts)
  vim.keymap.set({ 'n', 'x' }, '<C-w>F', '<Cmd>vertical wincmd F<CR>', opts)

  vim.keymap.set({ 'n', 't' }, '<C-.>', function()
    send_text(term, state.captured_context)
  end, opts)

  vim.keymap.set({ 'n', 't' }, '<D-v>', function()
    paste_text_or_image(term)
  end, opts)
  vim.keymap.set({ 'n', 't' }, '<C-v>', function()
    paste_text_or_image(term)
  end, opts)

  vim.keymap.set('n', '<C-p>', function()
    jump_to_prompt(buf, -1)
  end, opts)
  vim.keymap.set('n', '<C-n>', function()
    jump_to_prompt(buf, 1)
  end, opts)

  if assistant.disable_ctrl_d then
    vim.keymap.set('t', '<C-d>', '<Nop>', opts)
  end
end

local function setup_term_state(term, assistant)
  local term_state = get_term_state(term)

  term_state.cursor_image_workaround = assistant.cursor_image_workaround == true
end

local function capture_context_from_command_opts(opts)
  local source_buf = vim.api.nvim_get_current_buf()
  if not is_file_buffer(source_buf) then
    return ''
  end

  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  if opts.range > 0 then
    return build_context_range(source_buf, opts.line1, opts.line2)
  end

  return build_context_line(source_buf, current_line)
end

local function open_assistant_terminal(assistant, opts)
  local captured_context = capture_context_from_command_opts(opts)
  if captured_context ~= '' then
    set_pending_context(captured_context)
  end

  local cmd = assistant.name
  if opts.args and opts.args ~= '' then
    cmd = cmd .. ' ' .. opts.args
  end

  local term = Terminal:new({
    cmd = cmd,
    name = cmd,
    display_name = assistant.name,
    close_on_exit = false,
    on_open = function(t)
      term_label.apply(t)
      setup_term_state(t, assistant)
      configure_buffer(t, assistant)
    end,
    on_exit = function(t)
      term_label.clear(t)
      local term_state = state.terms[t.id]
      if term_state then
        cleanup_term_temp_files(term_state)
      end
      state.terms[t.id] = nil
    end,
  })

  term:open()
end

local function create_assistant_command(command_name)
  local assistant = assistants[command_name]
  pcall(vim.api.nvim_del_user_command, command_name)
  vim.api.nvim_create_user_command(command_name, function(opts)
    open_assistant_terminal(assistant, opts)
  end, {
    nargs = '*',
    range = true,
  })
end

function M.setup()
  for command_name, _ in pairs(assistants) do
    create_assistant_command(command_name)
  end

  vim.api.nvim_create_autocmd('VimLeavePre', {
    group = jump_highlight_augroup,
    callback = function()
      clear_jump_highlight()
      close_jump_highlight_timer()
    end,
  })
end

return M
