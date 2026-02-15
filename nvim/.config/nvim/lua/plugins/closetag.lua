local M = {}

function M.setup()
  -- Enable closetag for HTML/XML/JavaScript filetypes.
  vim.g.closetag_filetypes = 'html,xml,javascript'

  -- Enable closetag inside lit-html template regions in JavaScript.
  vim.g.closetag_regions = {
    javascript = 'litHtmlRegion',
  }
end

return M
