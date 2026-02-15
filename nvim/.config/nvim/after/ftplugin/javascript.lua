local function paste_clipboard_relative_path()
  local current_dir = vim.fn.expand('%:p:h')

  local clipboard_path = vim.fn.getreg('+')

  local clipboard_path_without_extension = vim.fn.fnamemodify(clipboard_path, ':r')

  local command = string.format(
    [[node -e "const path=require('path');process.stdout.write(path.relative(%q,%q))"]],
    current_dir,
    clipboard_path_without_extension
  )

  local relative_path = vim.fn.system(command)

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_err_writeln('Failed to compute relative path from clipboard with node')

    return
  end

  relative_path = relative_path:gsub('\n$', '')

  vim.api.nvim_put({ relative_path }, 'c', true, true)
end

-- Paste clipboard path as relative to current file directory.
vim.keymap.set('n', '\\v', paste_clipboard_relative_path, { buffer = true, silent = true })

-- Add JavaScript interpolation text objects.
pcall(vim.fn['textobj#user#plugin'], 'javascript', {
  interpolation = {
    pattern = { '${', '}' },
    ['select-a'] = '<buffer> ao',
    ['select-i'] = '<buffer> io',
  },
})

-- Resync syntax from file start when re-entering JavaScript buffers.
vim.api.nvim_create_autocmd('BufEnter', {
  buffer = 0,
  callback = function()
    vim.cmd('syntax sync fromstart')
  end,
})
