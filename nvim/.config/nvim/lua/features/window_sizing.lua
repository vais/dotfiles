local M = {}

function M.fit_current_window_to_content_width()
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  local max_content_width = 0
  for _, line in ipairs(lines) do
    local width = vim.fn.strdisplaywidth(line)
    if width > max_content_width then
      max_content_width = width
    end
  end

  local line_number_width = 0
  if vim.wo.number then
    local digit_width = tostring(vim.api.nvim_buf_line_count(buf)):len() + 1
    line_number_width = math.max(digit_width, vim.wo.numberwidth)
  end

  local target = math.max(vim.o.winwidth, max_content_width + line_number_width)
  local max_allowed = vim.o.columns
  vim.cmd('vertical resize ' .. math.min(max_allowed, target))
end

return M
