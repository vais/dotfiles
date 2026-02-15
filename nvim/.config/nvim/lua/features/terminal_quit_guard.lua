local M = {}

local MAX_LISTED_BUFFERS = 6

local always_exit_commands = {
  qa = true,
  qall = true,
  quitall = true,
  wqa = true,
  wqall = true,
  xa = true,
  xall = true,
  cq = true,
  cquit = true,
}

local maybe_exit_commands = {
  q = true,
  quit = true,
  wq = true,
  wquit = true,
  x = true,
  xit = true,
  exit = true,
}

local function parse_ex_command(cmdline)
  if not cmdline or vim.trim(cmdline) == '' then
    return nil
  end

  local ok, parsed = pcall(vim.api.nvim_parse_cmd, cmdline, {})
  if not ok or type(parsed) ~= 'table' then
    return nil
  end

  return parsed
end

local function is_running_terminal_buffer(buf)
  if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) then
    return false
  end
  if vim.bo[buf].buftype ~= 'terminal' then
    return false
  end

  local ok, job_id = pcall(vim.api.nvim_buf_get_var, buf, 'terminal_job_id')
  if not ok or type(job_id) ~= 'number' or job_id <= 0 then
    return false
  end

  return vim.fn.jobwait({ job_id }, 0)[1] == -1
end

local function get_running_terminal_buffers()
  local running_buffers = {}

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if is_running_terminal_buffer(buf) then
      table.insert(running_buffers, buf)
    end
  end

  return running_buffers
end

local function build_refusal_message(running_buffers)
  local listed = {}
  for i = 1, math.min(#running_buffers, MAX_LISTED_BUFFERS) do
    table.insert(listed, tostring(running_buffers[i]))
  end

  local extra = #running_buffers - #listed
  local extra_text = extra > 0 and string.format(', +%d', extra) or ''
  return string.format('E947: Job still running in buffer(s) %s%s. Use ! to force.', table.concat(listed, ','), extra_text)
end

local function is_real_window(win)
  local cfg = vim.api.nvim_win_get_config(win)
  return cfg.relative == ''
end

local function would_exit_nvim_for_current_layout()
  local tabs = vim.api.nvim_list_tabpages()
  if #tabs ~= 1 then
    return false
  end

  local real_window_count = 0
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabs[1])) do
    if vim.api.nvim_win_is_valid(win) and is_real_window(win) then
      real_window_count = real_window_count + 1
    end
  end

  return real_window_count <= 1
end

local function command_can_exit_nvim(cmd)
  if always_exit_commands[cmd] then
    return true
  end

  if maybe_exit_commands[cmd] then
    return would_exit_nvim_for_current_layout()
  end

  return false
end

function M.should_block_cmdline(cmdline)
  local parsed = parse_ex_command(cmdline)
  if not parsed then
    return false
  end

  local cmd = string.lower(parsed.cmd or '')
  if parsed.bang or not command_can_exit_nvim(cmd) then
    return false
  end

  local running_buffers = get_running_terminal_buffers()
  if #running_buffers == 0 then
    return false
  end

  return true, build_refusal_message(running_buffers)
end

return M
