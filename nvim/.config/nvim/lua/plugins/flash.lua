local M = {}

function M.setup()
  require('flash').setup({
    label = {
      uppercase = false,
    },
    modes = {
      char = {
        enabled = false,
      },
    },
  })

  vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>j', function()
    require('flash').jump({
      search = {
        multi_window = true,
      },
    })
  end, { silent = true })

  vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>j<CR>', function()
    require('flash').jump({
      search = { mode = 'search', max_length = 0, multi_window = true },
      label = { after = { 0, 0 }, uppercase = true },
      pattern = '^',
    })
  end, { silent = true })

  vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>j<Space>', function()
    require('flash').jump({
      search = { mode = 'search', max_length = 0, multi_window = true },
      label = { after = { 0, 0 }, uppercase = true },
      pattern = '^\\s*$',
    })
  end, { silent = true })
end

return M
