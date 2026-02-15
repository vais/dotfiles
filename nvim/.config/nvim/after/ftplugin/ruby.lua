-- Expand pry abbreviation into binding helper.
vim.cmd([[iabbrev <buffer> pry require 'pry'; binding.pry<Space>]])

-- Expand irb abbreviation into binding helper.
vim.cmd([[iabbrev <buffer> irb require 'irb'; binding.irb<Space>]])

-- Add Ruby interpolation text objects.
pcall(vim.fn['textobj#user#plugin'], 'ruby', {
  interpolation = {
    pattern = { '#{', '}' },
    ['select-a'] = '<buffer> ao',
    ['select-i'] = '<buffer> io',
  },
})
