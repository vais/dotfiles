local M = {}

function M.setup()
  -- Prefer Ruby block indentation style based on do/end.
  vim.g.ruby_indent_block_style = 'do'
end

return M
