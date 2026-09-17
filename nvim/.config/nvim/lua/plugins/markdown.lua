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

  -- Keep markdown-preview.nvim manual and local-only by default.
  vim.g.mkdp_auto_start = 0
  -- Keep the preview alive until it is stopped explicitly. In particular,
  -- switching away from or closing the Markdown buffer should not close the
  -- browser tab.
  vim.g.mkdp_auto_close = 0
  vim.g.mkdp_refresh_slow = 0
  vim.g.mkdp_open_to_the_world = 0
  vim.g.mkdp_echo_preview_url = 1
  vim.g.mkdp_filetypes = { 'markdown' }
  vim.g.mkdp_page_title = '${name}'
  vim.g.mkdp_preview_options = {
    disable_sync_scroll = 1,
  }

  local group = vim.api.nvim_create_augroup('MarkdownPreviewKeymaps', { clear = true })
  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = 'markdown',
    callback = function(event)
      local opts = { buffer = event.buf, silent = true }

      vim.keymap.set('n', '<Leader>mp', '<Cmd>MarkdownPreview<CR>', opts)
      vim.keymap.set('n', '<Leader>mP', '<Cmd>MarkdownPreviewStop<CR>', opts)
      vim.keymap.set('n', '<Leader>mt', '<Cmd>MarkdownPreviewToggle<CR>', opts)
    end,
  })
end

return M
