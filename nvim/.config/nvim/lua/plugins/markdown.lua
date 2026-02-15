local M = {}

function M.setup()
  -- Disable vim-markdown custom folding.
  vim.g.vim_markdown_folding_disabled = 1

  -- Keep native markdown folding enabled.
  vim.g.markdown_folding = 1

  -- Auto-fit the table-of-contents window width.
  vim.g.vim_markdown_toc_autofit = 1

  -- Disable markdown conceal.
  vim.g.vim_markdown_conceal = 0

  -- Disable code block conceal.
  vim.g.vim_markdown_conceal_code_blocks = 0

  -- Treat fenced js blocks as JavaScript.
  vim.g.vim_markdown_fenced_languages = { 'js=javascript' }
end

return M
