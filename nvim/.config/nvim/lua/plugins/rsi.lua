local M = {}

local function ctrl_k()
  local cmdline = vim.fn.getcmdline()
  local pos = vim.fn.getcmdpos()

  -- Mirror vim-rsi's kill behavior by storing deleted text in the "-" register.
  if pos <= vim.fn.strchars(cmdline) then
    vim.fn.setreg('-', vim.fn.strcharpart(cmdline, pos - 1))
  end

  return [[<C-\>e(strpart(getcmdline(),0,getcmdpos()-1))<CR>]]
end

function M.setup()
  -- In command-line mode, make <C-k> delete from cursor to end of line.
  vim.keymap.set('c', '<C-k>', ctrl_k, { expr = true })
end

return M
