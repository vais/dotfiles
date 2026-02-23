local M = {}

function M.scroll_move(direction)
  local scroll = direction == 'down' and '<C-e>' or '<C-y>'

  if direction == 'down' then
    if vim.fn.winline() == 1 then
      return scroll
    end
  else
    if vim.fn.winline() == vim.fn.winheight(0) then
      return scroll
    end
  end

  if vim.wo.wrap then
    return scroll .. (direction == 'down' and 'gj' or 'gk')
  end

  return scroll .. (direction == 'down' and 'j' or 'k')
end

function M.setup()
  -- Scroll viewport down and keep cursor movement wrap-aware.
  vim.keymap.set({ 'n', 'x', 'o' }, '<C-j>', function()
    return M.scroll_move('down')
  end, { expr = true })

  -- Scroll viewport up and keep cursor movement wrap-aware.
  vim.keymap.set({ 'n', 'x', 'o' }, '<C-k>', function()
    return M.scroll_move('up')
  end, { expr = true })
end

return M
