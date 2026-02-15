local M = {}

function M.exit_visual_mode()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'nx', false)
end

function M.copy_visual_path_and_exit(copy_path, kind)
  copy_path.copy_visual_file_path(kind)

  M.exit_visual_mode()
end

return M
